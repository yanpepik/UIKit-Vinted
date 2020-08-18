public class LoaderView: UIView {
    private let iconView = IconView()
    private let loadingView = LoadingView()
    private let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double.pi * 2
        animation.duration = 1
        animation.repeatCount = .infinity
        return animation
    }()

    private var loader: Loader? {
        didSet {
            update()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return loader?.size.size ?? IconSize.large.size
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .clear
        embed(view: iconView, inContainerView: self)
        embed(view: loadingView, inContainerView: self)
    }
    
    // MARK: - Public
    
    public func setup(loader: Loader) {
        iconView.setup(dto: Icon(image: loader.state.image, size: iconSize(for: loader.size)))
        self.loader = loader
        iconView.isHidden = loader.state == .loading
        loadingView.isHidden = loader.state != .loading
        loadingView.lineWidth = loader.size.lineWidth
        if let color = loader.theme?.primaryColor {
            loadingView.lineColor = color
        }
        updateLoadingViewPadding(size: loader.size)
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        update()
    }

    // MARK: - Private

    private func update() {
        guard window != nil, let loader = loader else {
            return
        }
        
        switch loader.state {
        case .loading:
            startAnimating()
        case .success, .failure:
            stopAnimating()
        }
    }

    private func startAnimating() {
        guard loader?.state == .loading else {
            return
        }
        loadingView.startAnimating()
    }

    private func stopAnimating() {
        loadingView.stopAnimating()
    }

    private func updateLoadingViewPadding(size: LoaderSize) {
        constraints.forEach { constraint in
            guard (constraint.firstItem is LoadingView || constraint.secondItem is LoadingView) &&
                  (constraint.firstItem is LoaderView || constraint.secondItem is LoaderView) else {
                return
            }
            constraint.constant = size.padding
        }
        layoutIfNeeded()
    }

    private func iconSize(for size: LoaderSize) -> IconSize {
        switch size {
        case .small: return .xSmall
        case .default: return .regular
        case .medium: return .small
        case .large: return .medium
        case .xLarge: return .large
        case .xxLarge: return .xLarge
        case .xxxLarge: return .xxLarge
        }
    }
}
