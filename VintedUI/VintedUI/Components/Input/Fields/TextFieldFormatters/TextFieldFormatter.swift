public class TextFieldFormatter: NSObject, TextFieldFormatable {
    public let isSecureTextField = false
    public let maxLength: Int
    
    public let autocapitalizationType: UITextAutocapitalizationType
    public let autocorrectionType: UITextAutocorrectionType
    public let spellcheckingType: UITextSpellCheckingType
    public let returnKeyType: UIReturnKeyType
    public let keyboardType: UIKeyboardType
    public let contentType: UITextContentType?
    
    @objc
    public init(autocapitalizationType: UITextAutocapitalizationType = .none,
                autocorrectionType: UITextAutocorrectionType = .default,
                spellcheckingType: UITextSpellCheckingType = .default,
                returnKeyType: UIReturnKeyType = .default,
                keyboardType: UIKeyboardType = .default,
                contentType: UITextContentType? = nil) {
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellcheckingType = spellcheckingType
        self.returnKeyType = returnKeyType
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.maxLength = Int.max
        super.init()
    }
    
    @objc
    public init(autocapitalizationType: UITextAutocapitalizationType = .none,
                autocorrectionType: UITextAutocorrectionType = .default,
                spellcheckingType: UITextSpellCheckingType = .default,
                returnKeyType: UIReturnKeyType = .default,
                keyboardType: UIKeyboardType = .default,
                contentType: UITextContentType? = nil,
                maxLength: Int) {
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellcheckingType = spellcheckingType
        self.returnKeyType = returnKeyType
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.maxLength = maxLength
        super.init()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldLength = textField.text?.count ?? 0
        let replacementLength = string.count
        let rangeLength = range.length
        
        let newLength = oldLength - rangeLength + replacementLength
        return newLength <= maxLength
    }
    
    public func parseValue(_ textField: UITextField) -> String? {
        return textField.text
    }
    
    public func textBeforeFocus(_ textField: UITextField) -> String? {
        return textField.text
    }
    
    public func textAfterFocus(_ textField: UITextField) -> String? {
        return textField.text
    }
}

extension TextFieldFormatter {

    public static func fullName(with maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocapitalizationType: .words,
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: .namePhonePad,
            maxLength: maxLength
        )
    }

    public static func addressLine(maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocapitalizationType: .sentences,
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: .default,
            maxLength: maxLength
        )
    }

    public static func postalCode(maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default, keyboardType: UIKeyboardType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocapitalizationType: .allCharacters,
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: keyboardType,
            maxLength: maxLength
        )
    }

    public static func city(maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocapitalizationType: .words,
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: .namePhonePad,
            maxLength: maxLength
        )
    }
    
    public static let email = TextFieldFormatter(
        autocapitalizationType: .none,
        autocorrectionType: .no,
        spellcheckingType: .no,
        keyboardType: .emailAddress
    )
    
    public static func phoneNumber(with maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: .phonePad,
            maxLength: maxLength
        )
    }

    public static func ssn(with maxLength: Int = .max, returnKeyType: UIReturnKeyType = .default) -> TextFieldFormatter {
        return TextFieldFormatter(
            autocorrectionType: .no,
            spellcheckingType: .no,
            returnKeyType: returnKeyType,
            keyboardType: .numberPad,
            maxLength: maxLength
        )
    }
}
