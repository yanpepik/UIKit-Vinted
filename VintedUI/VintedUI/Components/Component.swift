public protocol Component {
    func createView() -> UIView
    func canReuse(view: UIView) -> Bool
    func setupView(view: UIView)
}

extension Component {
    public func createView() -> UIView {
        return createView()
    }
    
    public func canReuse(view: UIView) -> Bool {
        return canReuse(view: view)
    }
    
    public func setupView(view: UIView) {
        setupView(view: view)
    }
    
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

final class ComponentAdapter: NSObject, ViewData {
    public func setupView(view: UIView) {
        component.setupView(view: view)
    }
    
    public func canReuse(view: UIView) -> Bool {
        return component.canReuse(view: view)
    }
    
    let component: Component
    
    init(component: Component) {
        self.component = component
        super.init()
    }
    
    public func createView() -> UIView {
        return component.createView()
    }
}

extension Component {
    public var viewData: ViewData {
        return ComponentAdapter(component: self)
    }
}
