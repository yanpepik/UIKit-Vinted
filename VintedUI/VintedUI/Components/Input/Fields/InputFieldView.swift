protocol InputFieldView {
    func setup(dto: InputField, inversed: Bool)
    func canReuse(dto: InputField) -> Bool
    
    var didBecomeFirstResponder: (() -> ())? { get set }
    var didResignFirstResponder: (() -> ())? { get set }
}
