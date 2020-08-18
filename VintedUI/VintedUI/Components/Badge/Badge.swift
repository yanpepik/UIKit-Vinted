public class Badge: NSObject {
    let theme: VintedTheme
    let text: String
    let icon: Icon?

    @objc
    public init(text: String = "", icon: Icon? = nil, theme: VintedTheme = .none) {
        self.text = text
        self.theme = theme
        self.icon = icon
        super.init()
    }
}

extension Badge: ViewData {
    public func createView() -> UIView {
        let view = BadgeView()
        setupView(view: view)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is BadgeView
    }

    public func setupView(view: UIView) {
        (view as? BadgeView)?.setup(badge: self)
    }
}
