extension NSAttributedString {
    @objc
    public convenience init(
        string: String,
        type: VintedTextType,
        inversed: Bool = false,
        theme: VintedTheme = .none,
        alignment: NSTextAlignment = .left,
        alpha: CGFloat = 1
        ) {
        let attributes = VintedUI.textAttributes(
            type: type,
            inversed: inversed,
            theme: theme,
            alignment: alignment,
            alpha: alpha
        )
        self.init(string: string, attributes: attributes)
    }
}
