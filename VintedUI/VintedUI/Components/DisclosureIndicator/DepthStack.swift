public final class DepthStack: NSObject {
    let items: [ViewData]
    
    public init(items: [ViewData]) {
        self.items = items
        super.init()
    }
}

public final class DepthStackView: UIView {
    func setup(stack: DepthStack) {
        backgroundColor = .clear
        removeSubviews()
        stack.items.forEach { component in
            embed(view: component.createView(), inContainerView: self)
        }
    }
}

extension DepthStack: ViewData {
    
    public func createView() -> UIView {
        let view = DepthStackView(frame: .zero)
        setupView(view: view)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is DepthStackView
    }
    
    public func setupView(view: UIView) {
        (view as? DepthStackView)?.setup(stack: self)
    }
}

extension ViewData {
    public func inFront(of view: ViewData) -> ViewData {
        return DepthStack(items: [view, self])
    }
    
    public func behind(of view: ViewData) -> ViewData {
        return DepthStack(items: [self, view])
    }
}
