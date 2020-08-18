public class VintedActivityIndicatorView: UIActivityIndicatorView {
    let loaderView = LoaderView()
    var animation: CABasicAnimation!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        initialize()
    }
    
    private func initialize() {
        subviews[0].isHidden = true
        loaderView.setup(loader: Loader(state: .loading, size: .medium, theme: .primary))
        loaderView.frame = bounds
        addSubview(loaderView)
    }
    
    override open var hidesWhenStopped: Bool {
        didSet {
            loaderView.isHidden = hidesWhenStopped && !isAnimating
        }
    }
    
    override public func startAnimating() {
        super.startAnimating()
        
        loaderView.isHidden = false
    }
    
    override public func stopAnimating() {
        super.stopAnimating()

        loaderView.isHidden = true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        loaderView.frame = bounds
    }
}
