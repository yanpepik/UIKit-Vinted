public typealias TextFieldReturnAction = () -> ()

public class TextField: NSObject, InputField {
    let loadableImage: LoadableImage?
    let placeholder: String?
    let value: String?
    let readOnly: Bool
    let shouldDismissKeyboardOnReturn: Bool
    let formatter: TextFieldFormatable
    let accessibilityIdentifier: String?
    
    let editingBegan: InputEditingAction?
    let editingEnded: InputEditingAction?
    let editingChanged: InputEditingAction?
    let onReturn: TextFieldReturnAction?
    let onIconTap: (() -> ())?

    public init(value: String?,
                placeholder: String?,
                loadableIcon: LoadableImage?,
                readOnly: Bool = false,
                shouldDismissKeyboardOnReturn: Bool = false,
                formatter: TextFieldFormatable,
                accessibilityIdentifier: String? = nil,
                editingBegan: InputEditingAction? = nil,
                editingEnded: InputEditingAction? = nil,
                editingChanged: InputEditingAction? = nil,
                onReturn: TextFieldReturnAction? = nil,
                onIconTap: (() -> ())? = nil) {
        self.value = value
        self.placeholder = placeholder
        self.loadableImage = loadableIcon
        self.formatter = formatter
        self.accessibilityIdentifier = accessibilityIdentifier
        self.editingBegan = editingBegan
        self.editingEnded = editingEnded
        self.editingChanged = editingChanged
        self.onReturn = onReturn
        self.onIconTap = onIconTap
        self.readOnly = readOnly
        self.shouldDismissKeyboardOnReturn = shouldDismissKeyboardOnReturn
        super.init()
    }
    
    @objc
    public convenience init(value: String?,
                            placeholder: String?,
                            icon: UIImage?,
                            shouldDismissKeyboardOnReturn: Bool = false,
                            formatter: TextFieldFormatable,
                            accessibilityIdentifier: String? = nil,
                            editingBegan: InputEditingAction? = nil,
                            editingEnded: InputEditingAction? = nil,
                            editingChanged: InputEditingAction? = nil,
                            onReturn: TextFieldReturnAction? = nil,
                            onIconTap: (() -> ())? = nil) {
        self.init(
            value: value,
            placeholder: placeholder,
            icon: icon,
            readOnly: false,
            shouldDismissKeyboardOnReturn: shouldDismissKeyboardOnReturn,
            formatter: formatter,
            accessibilityIdentifier: accessibilityIdentifier,
            editingBegan: editingBegan,
            editingEnded: editingEnded,
            editingChanged: editingChanged,
            onReturn: onReturn,
            onIconTap: onIconTap
        )
    }
    
    @objc
    public convenience init(value: String? = nil,
                            placeholder: String? = nil,
                            icon: UIImage? = nil,
                            readOnly: Bool = false,
                            shouldDismissKeyboardOnReturn: Bool = false,
                            formatter: TextFieldFormatable,
                            accessibilityIdentifier: String? = nil,
                            editingBegan: InputEditingAction? = nil,
                            editingEnded: InputEditingAction? = nil,
                            editingChanged: InputEditingAction? = nil,
                            onReturn: TextFieldReturnAction? = nil,
                            onIconTap: (() -> ())? = nil) {
        self.init(
            value: value,
            placeholder: placeholder,
            loadableIcon: icon.map { LoadableImage(image: $0) },
            readOnly: readOnly,
            shouldDismissKeyboardOnReturn: shouldDismissKeyboardOnReturn,
            formatter: formatter,
            accessibilityIdentifier: accessibilityIdentifier,
            editingBegan: editingBegan,
            editingEnded: editingEnded,
            editingChanged: editingChanged,
            onReturn: onReturn,
            onIconTap: onIconTap
        )
    }
    
    public func createField() -> UIView {
        return TextFieldView()
    }
}
