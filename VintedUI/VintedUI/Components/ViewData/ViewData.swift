@objc
public protocol ViewData {
    @objc
    func createView() -> UIView
    func canReuse(view: UIView) -> Bool
    func setupView(view: UIView)
}

extension ViewData {
    
    @discardableResult
    public func show(in containerView: UIView) -> UIView {
        if let view = reusableView(in: containerView) {
            setupView(view: view)
            return view
        } else {
            containerView.removeSubviews()
            let view = createView()
            embed(view: view, inContainerView: containerView)
            return view
        }
    }
    
    func reusableView(in containerView: UIView) -> UIView? {
        guard let view = containerView.subviews.last,
            containerView.subviews.count == 1,
            canReuse(view: view)
        else {
            return nil
        }
        
        return view
    }
}
