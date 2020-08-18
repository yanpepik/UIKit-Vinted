public class DividerDTO: NSObject {
    let inversed: Bool
    let orientation: DividerOrientation
    
    public init(orientation: DividerOrientation, inversed: Bool = false) {
        self.inversed = inversed
        self.orientation = orientation
        super.init()
    }

    @objc
    public init(orientation: DividerOrientation) {
        self.inversed = false
        self.orientation = orientation
        super.init()
    }
}

extension DividerDTO: ViewData {
    public func createView() -> UIView {
        let view = DividerView()
        setupView(view: view)
        return view
    }
    
    public func canReuse(view: UIView) -> Bool {
        return view is DividerView
    }
    
    public func setupView(view: UIView) {
        if let divider = view as? DividerView {
            divider.setup(dto: self)
            setupConstraints(dividerView: divider)
        }
    }
    
    private func setupConstraints(dividerView: DividerView) {
        dividerView.removeConstraints(dividerView.constraints)
        if orientation == .horizontal {
            dividerView.addConstraint(NSLayoutConstraint(item: dividerView, attribute: .height, constant: DividerThickness))
        } else {
            dividerView.addConstraint(NSLayoutConstraint(item: dividerView, attribute: .width, constant: DividerThickness))
        }
    }
}
