public class ActivityIndicator: NSObject {
    let animating: Bool
    let inversed: Bool
    
    @objc
    public init(animating: Bool = true, inversed: Bool = false) {
        self.animating = animating
        self.inversed = inversed
        super.init()
    }
}

extension ActivityIndicator: ViewData {
    public func createView() -> UIView {
        let view = VintedActivityIndicatorView(style: inversed ? .white : .gray)
        view.hidesWhenStopped = true
        setupView(view: view)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is VintedActivityIndicatorView
    }

    public func setupView(view: UIView) {
        guard let view = view as? VintedActivityIndicatorView else {
            return
        }

        if animating {
            view.startAnimating()
        } else {
            view.stopAnimating()
        }
    }
}
