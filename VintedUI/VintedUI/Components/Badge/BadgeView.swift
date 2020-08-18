public class BadgeView: UIView {
    private var shadowColor: UIColor?
    private var paddingConstraints: [NSLayoutConstraint]?
    private var badgeAutoLayoutView: BadgeAutoLayoutContentView?
    private var contentView: BadgeViewContent?

    public override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2
            setupShadow()
        }
    }

    public override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
            setupShadow()
        }
    }

    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)
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
        let appearance = NormalBadgeAppearance()
        let paddings = UIEdgeInsets(
            top: appearance.topMargin,
            left: appearance.leftMargin,
            bottom: appearance.bottomMargin,
            right: appearance.rightMargin
        )

        let badgeAutoLayoutView = BadgeAutoLayoutContentView.fromNib()
        self.paddingConstraints = embed(view: badgeAutoLayoutView, inContainerView: self)
        self.badgeAutoLayoutView = badgeAutoLayoutView
        self.contentView = badgeAutoLayoutView
       
        setupPaddings(paddings)
    }

    // MARK: - setup

    public func setup(badge: Badge) {
        badgeAutoLayoutView?.setup(badge: badge)
        
        backgroundColor = badge.theme.cellBackgroundColor

        shadowColor = badge.theme == .none ? Color(.grayscale1, alpha: 0.24) : nil
        setupShadow()
    }

    private func setupShadow() {
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: bounds.size), cornerRadius: layer.cornerRadius).cgPath

        if let shadowColor = shadowColor {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.5
            layer.shadowPath = path
        } else {
            layer.shadowPath = nil
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowOffset = CGSize.zero
        }
    }

    // MARK: - Shrink

    @available(iOS 10, *)
    @available(swift, obsoleted: 3.0)
    @objc
    public func shrink(withCenter center: CGPoint) {
        shrink(center: center)
    }

    @available(iOS 10, *)
    public func shrink(center: CGPoint? = nil) {
        contentView?.removeText()

        let appearance = CircleBadgeAppearance()
        let newOrigin: CGPoint

        if let center = center {
            newOrigin = CGPoint(x: center.x - appearance.minWidth / 2, y: center.y - appearance.minHeight / 2)
        } else {
            newOrigin = frame.origin
        }

        let animationDuration = 0.2

        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear) {
            let paddings = UIEdgeInsets(
                top: appearance.topMargin,
                left: appearance.leftMargin,
                bottom: appearance.bottomMargin,
                right: appearance.rightMargin
            )

            self.setupPaddings(paddings)
            self.backgroundColor = appearance.borderColor
            self.badgeAutoLayoutView?.setupConstraints(appearance: appearance)
            self.frame = CGRect(origin: newOrigin, size: CGSize(width: appearance.minWidth, height: appearance.minHeight))
            self.layer.cornerRadius = (appearance.minHeight + paddings.top + paddings.bottom) / 2
            self.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    private func setupPaddings(_ paddings: UIEdgeInsets) {
        if let paddingConstraints = self.paddingConstraints {
            paddingConstraints[0].constant = paddings.top
            paddingConstraints[1].constant = paddings.right
            paddingConstraints[2].constant = paddings.bottom
            paddingConstraints[3].constant = paddings.left
        }
    }
}
