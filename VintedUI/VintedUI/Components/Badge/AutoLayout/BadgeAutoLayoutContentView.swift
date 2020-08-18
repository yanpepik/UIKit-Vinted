// http://ui.vinted.net/atoms/badge.html

final class BadgeAutoLayoutContentView: UIView, BadgeViewContent, NibLoadable {
    @IBOutlet private var containerTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var containerBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var containerLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var containerRightMarginConstraint: NSLayoutConstraint!

    @IBOutlet private var textToLeftContainerConstraint: NSLayoutConstraint!
    @IBOutlet private var textToIconConstraint: NSLayoutConstraint!

    @IBOutlet private var containerMinHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var containerMinWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var iconTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var iconBottomMarginConstraint: NSLayoutConstraint!

    @IBOutlet private var textView: TextView!
    @IBOutlet private var iconView: IconView!

    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2
        }
    }

    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
        }
    }

    // MARK: - Lifecyle

    override func awakeFromNib() {
        super.awakeFromNib()

        // setup badge with dummy values to have correct constraints set up
        setup(badge: Badge())

        layer.masksToBounds = true
    }

    // MARK: - Setup

    func setup(badge: Badge) {
        var constraintsToActivate: [NSLayoutConstraint] = []
        var constraintsToDeactivate: [NSLayoutConstraint] = []

        backgroundColor = badge.theme.cellBackgroundColor
        
        let text = AttributedText(text: badge.text, type: .caption, theme: .none, inversed: badge.theme != .none, numberOfRows: 1, alignment: .center)
        textView.setup(text: text)

        if let icon = badge.icon {
            iconView.isHidden = false
            iconView.setup(dto: icon)

            constraintsToDeactivate.append(textToLeftContainerConstraint)
            constraintsToActivate.append(textToIconConstraint)
            constraintsToActivate.append(iconTopMarginConstraint)
            constraintsToActivate.append(iconBottomMarginConstraint)
        } else {
            iconView.isHidden = true
            constraintsToActivate.append(textToLeftContainerConstraint)
            constraintsToDeactivate.append(textToIconConstraint)
            constraintsToDeactivate.append(iconTopMarginConstraint)
            constraintsToDeactivate.append(iconBottomMarginConstraint)
        }

        let appearance: BadgeAppearance

        if badge.icon == nil && badge.text.isEmpty {
            appearance = CircleBadgeAppearance()
        } else {
            appearance = NormalBadgeAppearance()
        }

        setupConstraints(appearance: appearance)

        NSLayoutConstraint.deactivate(constraintsToDeactivate)
        NSLayoutConstraint.activate(constraintsToActivate)
    }

    func setupConstraints(appearance: BadgeAppearance) {
        containerMinWidthConstraint.constant = appearance.minWidth
        containerMinHeightConstraint.constant = appearance.minHeight

        textToLeftContainerConstraint.constant = 0
        textToIconConstraint.constant = appearance.marginBetweenIconAndText
    }

    func removeText() {
        textView.setup(text: AttributedText(text: ""))
    }
}
