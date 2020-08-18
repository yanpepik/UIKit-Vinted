public final class SearchBar: NSObject {
    @objc
    public static func component(text: String? = nil,
                                 placeholder: String? = nil,
                                 isEnabled: Bool = true,
                                 accessibilityIdentifier: String? = nil,
                                 onTap: (() -> ())? = nil,
                                 onClear: (() -> ())? = nil,
                                 onEditingChanged: InputEditingAction? = nil,
                                 onReturn: TextFieldReturnAction? = nil) -> InputBar {

        let formatter = TextFieldFormatter(returnKeyType: .search)
        let textField = TextField(
            value: text,
            placeholder: placeholder,
            icon: nil,
            readOnly: !isEnabled,
            formatter: formatter,
            editingChanged: onEditingChanged,
            onReturn: onReturn
        )

        let showClearButton = text?.isEmpty == false && isEnabled

        return InputBar(
            inputField: textField,
            suffix: showClearButton ? InputBarButton(icon: UIImage(named: "searchBarClearIcon", in: Bundle(for: SearchBar.self), compatibleWith: nil), accessibilityIdentifier: "clear", onTap: onClear) : nil,
            icon: Icon(image: UIImage(named: "searchBarSearchIcon", in: Bundle(for: SearchBar.self), compatibleWith: nil), size: .small, color: .grayscale4),
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
}
