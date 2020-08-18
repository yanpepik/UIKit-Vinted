// http://ui.vinted.net/molecules/input.html

private let ValidationPaddingTop = 1.units
private let DividerTopPadding = 1.units
private let TitlePaddingBottom = 2.units

final class InputAutoLayoutView: UIView, NibLoadable {
    @IBOutlet private var fieldContainer: UIView!
    @IBOutlet private var validationContainerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dividerView: DividerView!
    
    @IBOutlet private var validationPaddingTopConstraint: NSLayoutConstraint!
    @IBOutlet private var titlePaddingBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var dividerTopConstraint: NSLayoutConstraint!
    @IBOutlet private var titleWidthConstraint: NSLayoutConstraint!
    
    private var validationView = TextView()
    private var addedField: UIView?
    
    private var enabled = true

    private var title: String?
    private var inversed = false
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dividerTopConstraint.constant = DividerTopPadding
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setupTitle()
    }

    // MARK: - Setup
    
    func setup(dto: Input) {
        let inversed = dto.inversed

        self.title = dto.title
        self.inversed = dto.inversed

        setupTitle()

        if let addedField = addedField as? InputFieldView, addedField.canReuse(dto: dto.fieldDTO) {
            addedField.setup(dto: dto.fieldDTO, inversed: inversed)
        } else {
            addedField?.removeFromSuperview()
            let newField = dto.fieldDTO.createField()
            embed(view: newField, inContainerView: fieldContainer)
            if let newField = newField as? InputFieldView {
                newField.setup(dto: dto.fieldDTO, inversed: inversed)
            }
            addedField = newField
        }
        
        if var addedField = addedField as? InputFieldView {
            addedField.didBecomeFirstResponder = { [weak self] in self?.handleBecomeFirstResponder() }
            addedField.didResignFirstResponder = { [weak self] in self?.handleResignFirstResponder() }
        }
        
        if let validationDTO = dto.validationDTO {
            if validationView.superview == nil {
                embed(view: validationView, inContainerView: validationContainerView)
            }
            validationDTO.setupView(view: validationView)
            validationPaddingTopConstraint.constant = ValidationPaddingTop
        } else {
            validationPaddingTopConstraint.constant = 0
            validationView.removeFromSuperview()
        }
        
        self.enabled = dto.enabled
        addedField?.isUserInteractionEnabled = dto.enabled
        alpha = dto.enabled ? AlphaEnabled : AlphaDisabled
        
        if let addedField = addedField as? UIControl {
            addedField.isEnabled = self.enabled
        }
        
        dividerView.inverse = inversed
        self.accessibilityIdentifier = dto.accessibilityIdentifier
    }

    private func setupTitle() {
        if let titleAttributedString = attributedString() {
            titleLabel.attributedText = titleAttributedString
            titlePaddingBottomConstraint.constant = TitlePaddingBottom
            titleWidthConstraint.isActive = true
        } else {
            titleLabel.attributedText = nil
            titlePaddingBottomConstraint.constant = 0
            titleWidthConstraint.isActive = false
        }
    }

    // MARK: - Helpers

    private func attributedString() -> NSAttributedString? {
        let textType: VintedTextType = traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular ? .title : .subtitle
        return attributedText(string: title, type: textType, inversed: inversed, theme: .none, alignment: .left)
    }

    // MARK: - Actions
    
    func handleBecomeFirstResponder() {
        let color: UIColor
        if inversed {
            color = Color(.grayscale9, alpha: AlphaDisabled)
        } else {
            color = Color(.primary1, alpha: AlphaDisabled)
        }
        dividerView.color = color
    }
    
    func handleResignFirstResponder() {
        dividerView.color = nil
    }
    
    @objc
    private func handleTap() {
        becomeFirstResponder()
    }
    
    // MARK: - UIResponder override
    
    override var canBecomeFirstResponder: Bool {
        return enabled && (addedField?.canBecomeFirstResponder ?? false)
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return enabled && (addedField?.becomeFirstResponder() ?? false)
    }
    
    override var canResignFirstResponder: Bool {
        return enabled && (addedField?.canResignFirstResponder ?? false)
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return enabled && (addedField?.resignFirstResponder() ?? false)
    }

    override var isFirstResponder: Bool {
        return enabled && (addedField?.isFirstResponder ?? false)
    }
}
