public class Responsive: NSObject {
    let normal: ViewData
    let wide: ViewData

    public init(normal: ViewData, wide: ViewData) {
        self.normal = normal
        self.wide = wide
    }
}

extension Responsive: ViewData {
    public func createView() -> UIView {
        let view = ResponsiveView()
        view.setup(self)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is ResponsiveView
    }

    public func setupView(view: UIView) {
        (view as? ResponsiveView)?.setup(self)
    }
}
