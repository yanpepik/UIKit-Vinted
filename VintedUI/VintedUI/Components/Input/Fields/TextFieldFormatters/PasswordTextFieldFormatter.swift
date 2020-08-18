public enum PasswordType {
    case password
    case newPassword
    
    @available(iOS 12.0, *)
    var textContentType: UITextContentType {
        switch self {
        case .newPassword:
            return .newPassword
        case .password:
            return .password
        }
    }
}

public class PasswordTextFieldFormatter: NSObject, TextFieldFormatable {
    public let isSecureTextField: Bool
    public let returnKeyType: UIReturnKeyType
    
    public let autocapitalizationType = UITextAutocapitalizationType.none
    public let autocorrectionType = UITextAutocorrectionType.no
    public let spellcheckingType = UITextSpellCheckingType.no
    public let keyboardType = UIKeyboardType.default
    public let contentType: UITextContentType?
    
    public init(secure: Bool, passwordType: PasswordType, returnKeyType: UIReturnKeyType) {
        self.isSecureTextField = secure
        self.returnKeyType = returnKeyType
        if #available(iOS 12.0, *) {
            contentType = passwordType.textContentType
        } else {
            contentType = nil
        }
        super.init() 
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
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
