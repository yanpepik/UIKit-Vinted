public final class Input {
    let title: String?
    let fieldDTO: InputField
    let validationDTO: Validation?
    let inversed: Bool
    let enabled: Bool
    let accessibilityIdentifier: String?

    public init(
        title: String? = nil,
        fieldDTO: InputField,
        validationDTO: Validation? = nil,
        inversed: Bool = false,
        enabled: Bool = true,
        accessibilityIdentifier: String? = nil
        ) {
        self.title = title
        self.fieldDTO = fieldDTO
        self.validationDTO = validationDTO
        self.inversed = inversed
        self.enabled = enabled
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

extension Input: ViewData {
    public func createView() -> UIView {
        let view = InputAutoLayoutView.fromNib()
        setupView(view: view)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is InputAutoLayoutView
    }

    public func setupView(view: UIView) {
        (view as? InputAutoLayoutView)?.setup(dto: self)
    }
}

// MARK: - Obj-c helpers

extension Input {
    @available(swift, obsoleted: 3.0)
    public convenience init(title: String?, fieldDTO: InputField) {
        self.init(title: title, fieldDTO: fieldDTO, validationDTO: nil)
    }
    
    @available(swift, obsoleted: 3.0)
    public convenience init(fieldDTO: InputField) {
        self.init(title: nil, fieldDTO: fieldDTO, validationDTO: nil)
    }
    
    @available(swift, obsoleted: 3.0)
    public convenience init(
        title: String?,
        fieldDTO: InputField,
        validationDTO: Validation?
        ) {
        self.init(title: title, fieldDTO: fieldDTO, validationDTO: validationDTO, inversed: false, enabled: true)
    }
    
    @available(swift, obsoleted: 3.0)
    public convenience init(
        title: String?,
        fieldDTO: InputField,
        validationDTO: Validation?,
        enabled: Bool
        ) {
        self.init(title: title, fieldDTO: fieldDTO, validationDTO: validationDTO, inversed: false, enabled: enabled)
    }
}
