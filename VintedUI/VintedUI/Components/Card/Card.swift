public class Card {
    let view: ViewData
    let shadow: Shadow

    public init(view: ViewData, shadow: Shadow) {
        self.view = view
        self.shadow = shadow
    }
}

extension Card: ViewData {
    public func setupView(view: UIView) {
        (view as? CardView)?.setup(card: self)
    }

    public func createView() -> UIView {
        let view = CardView()
        view.setup(card: self)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is CardView
    }
}
