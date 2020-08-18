private let DefaultTextFieldHeight = 6.units

public typealias InputEditingAction = (_ value: String?) -> ()

public class TextFieldView: UITextField, InputFieldView {
    
    deinit {
        delegate = nil
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: DefaultTextFieldHeight)
    }
    
    var didBecomeFirstResponder: (() -> ())?
    var didResignFirstResponder: (() -> ())?
    
    public override var text: String? {
        get {
            return super.text
        }
        set {
            guard newValue != text else { return }
            super.text = newValue
        }
    }
    
    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    private func initialize() {
        rightViewMode = .always
        delegate = self
        addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        addConstraint(.init(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: DefaultTextFieldHeight
            )
        )
    }
    
    // MARK: - Callbacks
    
    private var onEditingBegan: InputEditingAction?
    private var onEditingEnded: InputEditingAction?
    private var onEditingChanged: InputEditingAction?
    private var onReturn: TextFieldReturnAction?
    private var formatter: TextFieldFormatable!

    // MARK: Variables

    private var readOnly = false
    private var shouldDismissKeyboardOnReturn = false
    
    // MARK: - InputFieldView protocol
    
    public func setup(dto: InputField, inversed: Bool) {
        guard let dto = dto as? TextField else {
            return
        }
        
        attributedPlaceholder = VintedUI.attributedText(
            string: dto.placeholder,
            type: .userInput,
            inversed: inversed,
            theme: .muted,
            alignment: .left,
            ignoreLineSpacing: true,
            alpha: 0.48
        )
        
        text = dto.value

        let attributes = textAttributes(type: .userInput, inversed: inversed, theme: .none, alignment: .left)
        textColor = attributes[NSAttributedString.Key.foregroundColor] as? UIColor
        font = attributes[NSAttributedString.Key.font] as? UIFont
        if inversed {
            tintColor = Color(.grayscale9)
        } else {
            tintColor = nil
        }
        
        onEditingBegan = dto.editingBegan
        onEditingChanged = dto.editingChanged
        onEditingEnded = dto.editingEnded
        onReturn = dto.onReturn
 
        formatter = dto.formatter
        accessibilityIdentifier = dto.accessibilityIdentifier

        autocapitalizationType = dto.formatter.autocapitalizationType
        spellCheckingType = dto.formatter.spellcheckingType
        autocorrectionType = dto.formatter.autocorrectionType
        isSecureTextEntry = dto.formatter.isSecureTextField
        keyboardType = dto.formatter.keyboardType
        returnKeyType = dto.formatter.returnKeyType
        readOnly = dto.readOnly
        shouldDismissKeyboardOnReturn = dto.shouldDismissKeyboardOnReturn
        isUserInteractionEnabled = !dto.readOnly
        if #available(iOS 12.0, *) {
            textContentType = dto.formatter.contentType
        }

        if let loadableImage = dto.loadableImage {
            let iconView = IconView()
            iconView.setup(
                dto: Icon(
                    loadableImage: loadableImage,
                    size: .small,
                    onTap: {
                        dto.onIconTap?()
                        if dto.formatter is PasswordTextFieldFormatter {
                            self.updatePasswordInput()
                        }
                    }
                )
            )
            iconView.frame.size = IconSize.regular.size
            rightView = iconView
        } else {
            rightView = nil
        }
    }
    
    func canReuse(dto: InputField) -> Bool {
        return dto is TextField
    }
    
    // MARK: - Actions
    
    @objc
    private func editingBegan(_ sender: Any) {
        text = formatter.textAfterFocus(self)
        onEditingBegan?(formatter.parseValue(self))
        didBecomeFirstResponder?()
    }
    
    @objc
    public func editingChanged(_ sender: Any) {
        onEditingChanged?(formatter.parseValue(self))
    }
    
    @objc
    private func editingEnded(_ sender: Any) {
        text = formatter.textBeforeFocus(self)
        onEditingEnded?(formatter.parseValue(self))
        didResignFirstResponder?()
    }
}

extension TextFieldView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()

        if shouldDismissKeyboardOnReturn {
            textField.resignFirstResponder()
        }
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
 
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !readOnly
    }
    
    private func updatePasswordInput() {
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
