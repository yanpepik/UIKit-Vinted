public class StackView: UIStackView {
    // MARK: - UIResponder override
    
    override public var canBecomeFirstResponder: Bool {
        return arrangedSubviews.first(where: { $0.canBecomeFirstResponder }) != nil
    }
    
    override public func becomeFirstResponder() -> Bool {
        for view in arrangedSubviews {
            if view.becomeFirstResponder() {
                return true
            }
        }
        return false
    }
    
    override public var canResignFirstResponder: Bool {
        return arrangedSubviews.first(where: { $0.canResignFirstResponder }) != nil
    }
    
    override public func resignFirstResponder() -> Bool {
        return arrangedSubviews.first(where: { $0.resignFirstResponder() }) != nil
    }

    override public var isFirstResponder: Bool {
        return arrangedSubviews.first(where: { $0.isFirstResponder }) != nil
    }
}
