private let MaxFractionalDigits = 2

public class CurrencyTextFieldFormatter: NSObject, TextFieldFormatable {
    public let returnKeyType: UIReturnKeyType
    
    public let isSecureTextField = false
    public let autocapitalizationType = UITextAutocapitalizationType.none
    public let autocorrectionType = UITextAutocorrectionType.no
    public let spellcheckingType = UITextSpellCheckingType.no
    public let keyboardType = UIKeyboardType.decimalPad
    public let contentType: UITextContentType? = nil
    
    let formatter: NumberFormatter
    var numberSet: CharacterSet {
        let numberSet = NSMutableCharacterSet.decimalDigit()
        numberSet.addCharacters(in: ".")
        numberSet.addCharacters(in: ",")
        return numberSet as CharacterSet
    }
    
    @objc
    public init(numberFormatter: NumberFormatter, returnKeyType: UIReturnKeyType) {
        self.formatter = numberFormatter
        self.returnKeyType = returnKeyType
        super.init()
    }
    
    // MARK: - Currency formatting
    
    @objc
    private func stringWithValidNumberCharactersFromString(_ originalString: String?) -> String? {
        guard let originalString = originalString else {
            return nil
        }
        
        let decimalSeparatorCharacter = formatter.decimalSeparator.first ?? Character(".")
        var strippedString = ""
        
        originalString.reversed().forEach { character in
            if ",.".contains(character) && !strippedString.contains(decimalSeparatorCharacter) {
                strippedString.append(decimalSeparatorCharacter)
            } else if "0123456789".contains(character) {
                strippedString.append(character)
            }
        }
        return String(strippedString.reversed())
    }
    
    @objc
    public func numberFromInputString(_ string: String) -> NSNumber {
        let numberString = string.replacingOccurrences(of: ",", with: ".")
        return NSNumber(value: (numberString as NSString).doubleValue as Double)
    }
    
    @objc
    public func formattedPriceString(_ price: NSNumber) -> String? {
        return formatter.string(from: price)
    }
    
    private func currencyStringFromInputString(_ string: String?) -> String? {
        guard let string = string else {
            return nil
        }
        
        if string.isEmpty {
            return string
        }
        
        let numberValue = numberFromInputString(string)
        return formattedPriceString(numberValue)
    }
    
    private func occurenciesOfSubstringInString(_ substring: String, string: String) -> Int {
        var count = 0
        let length = string.count
        var range = NSRange(location: 0, length: length)
        
        while range.location != NSNotFound {
            range = (string as NSString).range(of: substring,
                                               options: .caseInsensitive,
                                               range: range,
                                               locale: nil)
            if range.location != NSNotFound {
                range = NSRange(location: range.location + range.length, length: length - (range.location + range.length))
                count += 1
            }
        }
        return count
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        func validateCharacterCountAfterString(_ string: String, inString validatedString: NSString, count: Int) -> Bool {
            let range = validatedString.range(of: string)
            if range.length > 0 {
                let afterString = (validatedString as NSString).substring(from: range.location + 1)
                return afterString.count <= count
            }
            return true
        }
        
        let candidateValue = (textField.text! as NSString)
            .replacingCharacters(in: range, with: string)
        let invertedNumberSet = numberSet.inverted
        let commas = occurenciesOfSubstringInString(",", string: candidateValue)
        let dots = occurenciesOfSubstringInString(".", string: candidateValue)
        let onlyDotsOrNumbers = string.trimmingCharacters(in: invertedNumberSet).count > 0 ||
            string.isEmpty
        
        if !onlyDotsOrNumbers ||
            commas + dots > 1 ||
            !validateCharacterCountAfterString(",", inString: (candidateValue as NSString), count: MaxFractionalDigits) ||
            !validateCharacterCountAfterString(".", inString: (candidateValue as NSString), count: MaxFractionalDigits) {
            return false
        }
        
        return true
    }
    
    @objc
    public func parseValue(_ textField: UITextField) -> String? {
        return stringWithValidNumberCharactersFromString(textField.text)
    }
    
    public func textBeforeFocus(_ textField: UITextField) -> String? {
        return currencyStringFromInputString(textField.text)
    }
    
    public func textAfterFocus(_ textField: UITextField) -> String? {
        return stringWithValidNumberCharactersFromString(textField.text)
    }
}
