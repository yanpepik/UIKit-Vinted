public final class InputBar: NSObject {
    let inputField: InputField
    let suffix: InputBarButton?
    let icon: Icon?
    let prefix: InputBarButton?
    let accessibilityIdentifier: String?
    let onTap: (() -> ())?

    public init(inputField: InputField,
                suffix: InputBarButton? = nil,
                icon: Icon? = nil,
                prefix: InputBarButton? = nil,
                accessibilityIdentifier: String? = nil,
                onTap: (() -> ())? = nil) {
        self.inputField = inputField
        self.suffix = suffix
        self.icon = icon
        self.prefix = prefix
        self.accessibilityIdentifier = accessibilityIdentifier
        self.onTap = onTap
    }
}

extension InputBar: ViewData {
    public func canReuse(view: UIView) -> Bool {
        return view is InputBarView
    }

    public func setupView(view: UIView) {
        (view as? InputBarView)?.setup(self)
    }

    public func createView() -> UIView {
        let view = InputBarView()
        setupView(view: view)
        return view
    }
}
