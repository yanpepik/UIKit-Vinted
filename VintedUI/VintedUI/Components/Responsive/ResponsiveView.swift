class ResponsiveView: UIView {
    
    private var addedView: UIView?

    private var responsive: Responsive?

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            setupView()
        }
    }

    // MARK: - Setup

    func setup(_ responsive: Responsive) {
        self.responsive = responsive

        setupView()
    }

    private func setupView() {
        guard let responsive = responsive else {
            return
        }

        if traitCollection.horizontalSizeClass == .regular {
            setupView(with: responsive.wide)
        } else {
            setupView(with: responsive.normal)
        }
    }

    private func setupView(with viewData: ViewData) {
        if let addedView = addedView, viewData.canReuse(view: addedView) {
            viewData.setupView(view: addedView)
        } else {
            let view = viewData.createView()
            addedView?.removeFromSuperview()
            embed(view: view, inContainerView: self)
            addedView = view
        }
    }
}
