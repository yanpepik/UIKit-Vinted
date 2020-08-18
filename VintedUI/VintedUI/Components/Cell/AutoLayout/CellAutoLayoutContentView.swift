// http://ui.vinted.net/components/cell.html

extension VintedTheme {
    var cellBackgroundColor: UIColor {
        switch self {
        case .none:
            return Color(.grayscale9)
        default:
            return primaryColor
        }
    }
}

final class CellAutoLayoutContentView: VTBorderView, CellContentView, NibLoadable {
    // MARK: - Padding constraints
    @IBOutlet private var leftPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private var rightPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet private var leftValidationPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private var rightValidationPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomValidationPaddingConstraint: NSLayoutConstraint!

    // MARK: - Body container height
    @IBOutlet private var bodyContainerHidingConstraint: NSLayoutConstraint!

    // MARK: - Validation Label
    @IBOutlet private var validationLabel: UILabel!
    
    // MARK: - Containers
    @IBOutlet private var titleAndSubtitleContainerView: UIView!
    @IBOutlet private var contentContainerView: UIView!
    @IBOutlet private var rightSuffixContainerView: UIView!
    @IBOutlet private var leftSuffixContainerView: UIView!
    @IBOutlet private var bodyContainerView: UIView!

    // MARK: - Left and right suffix size constraints
    @IBOutlet private var rightSuffixWidth: NSLayoutConstraint!
    @IBOutlet private var leftSuffixHeight: NSLayoutConstraint!
    @IBOutlet private var leftSuffixWidth: NSLayoutConstraint!

    // MARK: - Spacing between suffixes
    @IBOutlet private var rightSuffixSpacing: NSLayoutConstraint!
    @IBOutlet private var leftSuffixSpacing: NSLayoutConstraint!

    @IBOutlet private var titleSubtitleZeroHeightConstraint: NSLayoutConstraint!

    private var previousTraitCollection: UITraitCollection?

    var forcedTraitCollection: UITraitCollection? {
        willSet {
            previousTraitCollection = traitCollection
        }
        didSet {
            guard let previousTraitCollection = previousTraitCollection else {
                return
            }
            traitCollectionDidChange(previousTraitCollection)
        }
    }

    // MARK: - Title and subtitle view

    private let titleAndSubtitleView = VintedCellTitleAndSubtitleView.fromNib()

    // MARK: - Cell properties

    private(set) var addedRightSuffixView: UIView?
    private(set) var addedLeftSuffixView: UIView?
    private(set) var addedBodyView: UIView?

    override var traitCollection: UITraitCollection {
        return forcedTraitCollection ?? super.traitCollection
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        validationLabel.preferredMaxLayoutWidth = frame.width - leftValidationPaddingConstraint.constant - rightValidationPaddingConstraint.constant
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        validationLabel.text = nil
    }

    @objc
    func setup(cell: Cell) {
        inverseBorders = cell.theme != .none
        validationLabel.attributedText = attributedText(string: cell.validation, type: .caption, inversed: cell.theme != .none, theme: .warning, alignment: .left)
        
        topPaddingConstraint.constant = cell.size.padding
        leftPaddingConstraint.constant = cell.size.padding
        leftValidationPaddingConstraint.constant = cell.size.padding
        rightPaddingConstraint.constant = cell.size.padding
        rightValidationPaddingConstraint.constant = cell.size.padding
        bottomValidationPaddingConstraint.constant = cell.size.padding
        leftSuffixSpacing.constant = cell.leftSuffix == nil ? 0 : cell.size.spacing
        rightSuffixSpacing.constant = cell.rightSuffix == nil ? 0 : cell.size.spacing
        bottomPaddingConstraint.constant = cell.validation == nil ? 0 : cell.size.spacing
        
        setupTitleAndSubtitleView(dto: cell)
        setupLeftSuffixView(suffixView: cell.leftSuffix)
        setupRightSuffixView(suffixView: cell.rightSuffix)
        setupBodyView(body: cell.body)
        
        setNeedsUpdateConstraints()
    }
    
    private func setupTitleAndSubtitleView(dto: Cell) {
        if (dto.title != nil) || (dto.subtitle != nil) || (dto.titleIcon != nil) {
            titleSubtitleZeroHeightConstraint.isActive = false
            titleAndSubtitleView.setupLabels(title: dto.title,
                                             subtitle: dto.subtitle,
                                             titleIcon: dto.titleIcon,
                                             inversed: dto.theme != .none)
            if titleAndSubtitleContainerView.subviews.isEmpty {
                embed(view: titleAndSubtitleView, inContainerView: titleAndSubtitleContainerView)
            }
        } else {
            titleSubtitleZeroHeightConstraint.isActive = true
            titleAndSubtitleContainerView.subviews.forEach { $0.removeFromSuperview() }
        }
    }

    private func setupLeftSuffixView(suffixView: CellLeftSideSuffixable?) {
        guard let suffixView = suffixView else {
            addedLeftSuffixView?.removeFromSuperview()
            addedLeftSuffixView = nil
            leftSuffixContainerView.isHidden = true
            leftSuffixWidth.constant = 0
            leftSuffixHeight.constant = 0
            return
        }

        leftSuffixContainerView.isHidden = false

        if let addedLeftSuffixView = addedLeftSuffixView, suffixView.canReuse(view: addedLeftSuffixView) {
            suffixView.setupView(view: addedLeftSuffixView)
            let preferredSize = suffixView.preferredLeftSideSuffixSize(view: addedLeftSuffixView)
            leftSuffixWidth.constant = preferredSize.width
            leftSuffixHeight.constant = preferredSize.height
        } else {
            addedLeftSuffixView?.removeFromSuperview()
            let view = suffixView.createView()
            let preferredSize = suffixView.preferredLeftSideSuffixSize(view: view)
            leftSuffixHeight.constant = preferredSize.height
            leftSuffixWidth.constant = preferredSize.width
            addedLeftSuffixView = view
            embed(view: view, inContainerView: leftSuffixContainerView)
        }
    }

    private func setupBodyView(body: ViewData?) {
        guard let body = body else {
            addedBodyView?.removeFromSuperview()
            addedBodyView = nil
            bodyContainerHidingConstraint.isActive = true
            return
        }

        bodyContainerHidingConstraint.isActive = false

        if let addedBodyView = addedBodyView, body.canReuse(view: addedBodyView) {
            body.setupView(view: addedBodyView)
        } else {
            addedBodyView?.removeFromSuperview()
            let view = body.createView()
            addedBodyView = view
            embed(view: view, inContainerView: bodyContainerView)
        }
    }

    private func setupRightSuffixView(suffixView: CellRightSideSuffixable?) {
        guard let suffixView = suffixView else {
            addedRightSuffixView?.removeFromSuperview()
            addedRightSuffixView = nil
            rightSuffixContainerView.isHidden = true
            rightSuffixWidth.constant = 0
            return
        }

        rightSuffixContainerView.isHidden = false

        if let addedRightSuffixView = addedRightSuffixView, suffixView.canReuse(view: addedRightSuffixView) {
            suffixView.setupView(view: addedRightSuffixView)
            rightSuffixWidth.constant = suffixView.preferredRightSideSuffixWidth(view: addedRightSuffixView)
        } else {
            addedRightSuffixView?.removeFromSuperview()
            let view = suffixView.createView()
            rightSuffixWidth.constant = suffixView.preferredRightSideSuffixWidth(view: view)
            addRightSuffixView(suffixView: view)
            addedRightSuffixView = view
        }
    }

    private func addRightSuffixView(suffixView: UIView) {
        rightSuffixContainerView.addSubview(suffixView)

        suffixView.translatesAutoresizingMaskIntoConstraints = false
        let layoutAttributes: [NSLayoutConstraint.Attribute] = [.left, .right, .centerY]
        for attribute in layoutAttributes {
            let constraint = NSLayoutConstraint(
                item: suffixView,
                attribute: attribute,
                relatedBy: .equal,
                toItem: rightSuffixContainerView,
                attribute: attribute,
                multiplier: 1.0,
                constant: 0
            )
            rightSuffixContainerView.addConstraint(constraint)
        }
    }
    
    // MARK: - UIResponder override
    
    override var canBecomeFirstResponder: Bool {
        return addedBodyView?.canBecomeFirstResponder ?? false
    }
    
    override func becomeFirstResponder() -> Bool {
        return addedBodyView?.becomeFirstResponder() ?? false
    }
    
    override var canResignFirstResponder: Bool {
        return addedBodyView?.canResignFirstResponder ?? false
    }
    
    override func resignFirstResponder() -> Bool {
        return addedBodyView?.resignFirstResponder() ?? false
    }

    override var isFirstResponder: Bool {
        return addedBodyView?.isFirstResponder ?? false
    }
}
