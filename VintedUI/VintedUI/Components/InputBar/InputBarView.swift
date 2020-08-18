final class InputBarView: UIView {
    let appearance = InputBarAppearance()

    private var addedView: UIView?
    private var addedField: UIView? {
        return (addedView as? InputBarAutoLayoutView)?.addedFieldView
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.layoutFittingExpandedSize.width, height: appearance.minHeight)
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: size.width,
            height: min(appearance.minHeight, size.height)
        )
    }

    private var tapGestureRecognizer: UITapGestureRecognizer!

    private var onTap: (() -> ())?

    // MARK: - Initializers

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: appearance.minHeight))
        initialize()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        backgroundColor = appearance.backgroundColor
        layer.cornerRadius = appearance.cornerRadius

        isUserInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Setup

    public func setup(_ inputBar: InputBar) {
        self.onTap = inputBar.onTap
        tapGestureRecognizer.isEnabled = inputBar.onTap != nil

        accessibilityIdentifier = inputBar.accessibilityIdentifier

        if let addedView = addedView as? InputBarAutoLayoutView {
            addedView.setup(inputBar)
        } else {
            let view = InputBarAutoLayoutView.fromNib()
            embed(view: view, inContainerView: self)
            self.addedView = view
            view.setup(inputBar)
        }
    }

    // MARK: - Actions

    @objc
    private func handleTap() {
        onTap?()
    }

    // MARK: - UIResponder override

    override public var canBecomeFirstResponder: Bool {
        return addedField?.canBecomeFirstResponder ?? false
    }

    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return addedField?.becomeFirstResponder() ?? false
    }

    override public var canResignFirstResponder: Bool {
        return addedField?.canResignFirstResponder ?? false
    }

    @discardableResult
    override public func resignFirstResponder() -> Bool {
        return addedField?.resignFirstResponder() ?? false
    }

    override public var isFirstResponder: Bool {
        return addedField?.isFirstResponder ?? false
    }
}
