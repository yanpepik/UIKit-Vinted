final class CardView: UIView {
    private var addedView: UIView?

    // MARK: - Initialize

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

    func initialize() {
        backgroundColor = .clear
    }

    override var bounds: CGRect {
        didSet {
            calculateShadowPath()
        }
    }

    // MARK: - Setup

    func setup(card: Card) {
        if let addedView = addedView, card.view.canReuse(view: addedView) {
            card.view.setupView(view: addedView)
        } else {
            let view = card.view.createView()
            embed(view: view, inContainerView: self)
            addedView = view
        }

        addedView?.layer.cornerRadius = RadiusSize.default.value(size: addedView?.size ?? .zero)
        addedView?.layer.masksToBounds = true

        layer.apply(shadow: card.shadow)
        
        calculateShadowPath()
    }

    private func calculateShadowPath() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: RadiusSize.default.value(size: frame.size)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
