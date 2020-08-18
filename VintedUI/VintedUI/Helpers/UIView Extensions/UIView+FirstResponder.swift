public extension UIView {
    
    func findFirstFocusableView() -> UIView? {
        if canBecomeFocused {
            return self
        }
        for view in subviews {
            if let responder = view.findFirstFocusableView() {
                return responder
            }
        }
        return nil
    }
    
    func currentFirstResponder() -> UIResponder? {
        if isFirstResponder {
            return self
        }
        for view in subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
