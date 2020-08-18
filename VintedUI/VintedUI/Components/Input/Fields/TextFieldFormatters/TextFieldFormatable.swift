@objc
public protocol TextFieldFormatable {
    var isSecureTextField: Bool { get }
    var autocapitalizationType: UITextAutocapitalizationType { get }
    var autocorrectionType: UITextAutocorrectionType { get }
    var spellcheckingType: UITextSpellCheckingType { get }
    var returnKeyType: UIReturnKeyType { get }
    var keyboardType: UIKeyboardType { get }
    var contentType: UITextContentType? { get }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func parseValue(_ textField: UITextField) -> String?
    func textBeforeFocus(_ textField: UITextField) -> String?
    func textAfterFocus(_ textField: UITextField) -> String?
}
