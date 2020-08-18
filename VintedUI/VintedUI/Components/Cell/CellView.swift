public class CellView: UIView {

    private var contentView: CellContentView!

    var forcedTraitCollection: UITraitCollection? {
        get {
            return contentView.forcedTraitCollection
        }
        set {
            contentView.forcedTraitCollection = newValue
        }
    }

    public var borders: [DividerBorder] {
        get {
            return contentView.borders
        }
        set {
            contentView.borders = newValue
        }
    }

    private var onTap: (() -> ())?
    private let tapLayer = CALayer()
    private let hightlightLayer = CALayer()
    private var longTapCancelled = false
    private var hidesTapLayer = false

    public var addedRightSuffixView: UIView? {
        return contentView.addedRightSuffixView
    }
    public var addedLeftSuffixView: UIView? {
        return contentView.addedLeftSuffixView
    }
    public var addedBodyView: UIView? {
        return contentView.addedBodyView
    }

    private var respondsToTouch: Bool {
        return onTap != nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        tapLayer.frame = CGRect(origin: CGPoint(), size: frame.size)
        hightlightLayer.frame = CGRect(origin: CGPoint(), size: frame.size)
    }

    // MARK: - Gesture recognizers
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        return UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }()
    private lazy var longTapGestureRecognizer: UILongPressGestureRecognizer = { [unowned self] in
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        gesture.minimumPressDuration = DelayToDetectTouchDown
        return gesture
    }()

    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        let cellView = CellAutoLayoutContentView.fromNib()
        embed(view: cellView, inContainerView: self)
        contentView = cellView

        tapLayer.backgroundColor = Color(.grayscale1, alpha: 0.04).cgColor
        hightlightLayer.backgroundColor = Color(.primary1, alpha: 0.08).cgColor

        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(longTapGestureRecognizer)
    }

    // MARK: - Setup

    @objc
    public func setup(dto cell: Cell) {
        contentView.setup(cell: cell)
        borders = cell.dividers ?? borders
        backgroundColor = cell.theme.cellBackgroundColor
        tapGestureRecognizer.isEnabled = cell.onTap != nil
        longTapGestureRecognizer.isEnabled = cell.onTap != nil
        accessibilityIdentifier = cell.accessibilityIdentifier

        onTap = cell.disabled ? nil : cell.onTap
        hidesTapLayer = cell.shouldHideTapLayer

        (contentView as? UIView)?.alpha = cell.disabled ? AlphaDisabled : AlphaEnabled

        setupHighlight(hightlighted: cell.highlighted)
    }

    private func setupHighlight(hightlighted: Bool) {
        guard hightlighted else {
            hightlightLayer.removeFromSuperlayer()
            return
        }

        if hightlightLayer.superlayer == nil {
            layer.addSublayer(hightlightLayer)
        }
    }

    // MARK: - UIResponder override

    override public var canBecomeFirstResponder: Bool {
        return contentView.canBecomeFirstResponder
    }

    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return contentView.becomeFirstResponder()
    }

    override public var canResignFirstResponder: Bool {
        return contentView.canResignFirstResponder
    }

    @discardableResult
    override public func resignFirstResponder() -> Bool {
        return contentView.resignFirstResponder()
    }

    override public var isFirstResponder: Bool {
        return contentView.isFirstResponder
    }

    // MARK: - Actions

    @objc
    private func handleTap(sender: UITapGestureRecognizer) {
        if respondsToTouch {
            if !hidesTapLayer {
                layer.addSublayer(tapLayer)
            }
            removeTapLayer(completion: { [weak self] in self?.onTap?() })
        }
    }

    @objc
    private func handleLongTap(sender: UILongPressGestureRecognizer) {
        if respondsToTouch {
            let location = sender.location(in: self)

            switch sender.state {
            case .began:
                longTapCancelled = false
                tapLayer.frame = CGRect(origin: CGPoint(), size: frame.size)
                if !hidesTapLayer {
                    layer.addSublayer(tapLayer)
                }
            case .cancelled:
                removeTapLayer()
            case .ended:
                if longTapCancelled {
                    removeTapLayer()
                } else {
                    removeTapLayer(completion: { [weak self] in self?.onTap?() })
                }
            case .changed:
                if location.x > frame.width || location.y > frame.height || location.x < 0 || location.y < 0 {
                    removeTapLayer()
                    longTapCancelled = true
                }
            case .failed:
                removeTapLayer()
            case .possible:
                break
            @unknown default:
                 break
            }
        }
    }

    private func removeTapLayer(completion: (() -> ())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + ClickedRemovalDelay) { [weak self] in
            self?.tapLayer.removeFromSuperlayer()
            completion?()
        }
    }
    
    // MARK: - Border configuration for Obj-c

    @objc
    public var leftBorder: Bool {
        get {
            return borders.contains(.left)
        }
        set {
            var newBorders = borders
            if !borders.contains(.left) && newValue {
                newBorders.append(.left)
            }
            if borders.contains(.left) && !newValue {
                newBorders = newBorders.filter({ $0 != .left })
            }
            borders = newBorders
        }
    }

    @objc
    public var rightBorder: Bool {
        get {
            return borders.contains(.right)
        }
        set {
            var newBorders = borders
            if !borders.contains(.right) && newValue {
                newBorders.append(.right)
            }
            if borders.contains(.right) && !newValue {
                newBorders = newBorders.filter({ $0 != .right })
            }
            borders = newBorders
        }
    }

    @objc
    public var topBorder: Bool {
        get {
            return borders.contains(.top)
        }
        set {
            var newBorders = borders
            if !borders.contains(.top) && newValue {
                newBorders.append(.top)
            }
            if borders.contains(.top) && !newValue {
                newBorders = newBorders.filter({ $0 != .top })
            }
            borders = newBorders
        }
    }

    @objc
    public var bottomBorder: Bool {
        get {
            return borders.contains(.bottom)
        }
        set {
            var newBorders = borders
            if !borders.contains(.bottom) && newValue {
                newBorders.append(.bottom)
            }
            if borders.contains(.bottom) && !newValue {
                newBorders = newBorders.filter({ $0 != .bottom })
            }
            borders = newBorders
        }
    }
}

protocol CellContentView {
    func setup(cell: Cell)

    var forcedTraitCollection: UITraitCollection? { get set }
    var borders: [DividerBorder] { get set }

    var addedRightSuffixView: UIView? { get }
    var addedLeftSuffixView: UIView? { get }
    var addedBodyView: UIView? { get }

    var canBecomeFirstResponder: Bool { get }
    func becomeFirstResponder() -> Bool
    var canResignFirstResponder: Bool { get }
    func resignFirstResponder() -> Bool
    var isFirstResponder: Bool { get }
}
