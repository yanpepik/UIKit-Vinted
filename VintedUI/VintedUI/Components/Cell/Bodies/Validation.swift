public final class Validation {
    let text: AttributedText
    
    public init(text: String?, linkRanges: [LinkRange] = [], theme: VintedTheme, inversed: Bool = false) {
        self.text = AttributedText(text: text, type: .caption, theme: theme, inversed: inversed).linkified(
            links: linkRanges.map { ($0.range, TextLink(onTap: $0.onTap)) }
        )
    }
    
    public convenience init(text: String?, theme: VintedTheme) {
        self.init(text: text, linkRanges: [], theme: theme)
    }
    
    public convenience init(text: String?) {
        self.init(text: text, theme: .muted)
    }
}

extension Validation: ViewData {
    public func createView() -> UIView {
        return text.createView()
    }

    public func canReuse(view: UIView) -> Bool {
        return text.canReuse(view: view)
    }

    public func setupView(view: UIView) {
        return text.setupView(view: view)
    }
}
