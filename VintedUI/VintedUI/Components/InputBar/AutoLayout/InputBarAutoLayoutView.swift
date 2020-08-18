final class InputBarAutoLayoutView: UIView, NibLoadable {
    private let appearance = InputBarAppearance()

    @IBOutlet private var inputContainerView: UIView!
    @IBOutlet private var iconContainerView: UIView!
    @IBOutlet private var prefixContainerView: UIView!
    @IBOutlet private var suffixContainerView: UIView!

    @IBOutlet private var iconContainerSizeConstaints: [NSLayoutConstraint]!
    @IBOutlet private var prefixContainerSizeConstaints: [NSLayoutConstraint]!
    @IBOutlet private var suffixContainerSizeConstaints: [NSLayoutConstraint]!

    @IBOutlet private var fieldContainerVerticalConstraints: [NSLayoutConstraint]!

    @IBOutlet private var fieldToIconConstraint: NSLayoutConstraint!
    @IBOutlet private var iconToPrefixConstaint: NSLayoutConstraint!
    @IBOutlet private var fieldToSuffixConstraint: NSLayoutConstraint!

    private(set) var addedFieldView: UIView?
    private var addedIconView: UIView?
    private var addedPrefixView: UIView?
    private var addedSuffixView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()

        fieldContainerVerticalConstraints.forEach({ $0.constant = appearance.paddingVertical })

        [
            iconToPrefixConstaint,
            fieldToSuffixConstraint,
        ].forEach({ $0?.constant = appearance.paddingHorizontal })

        let sizeHidingConstraints = iconContainerSizeConstaints + prefixContainerSizeConstaints + suffixContainerSizeConstaints
        sizeHidingConstraints.forEach({ $0.constant = 0 })
    }

    func setup(_ inputBar: InputBar) {
        setup(field: inputBar.inputField)
        setup(icon: inputBar.icon)
        setup(suffix: inputBar.suffix)
        setup(prefix: inputBar.prefix)
    }

    private func setup(field: InputField) {
        if let addedFieldView = addedFieldView as? InputFieldView, addedFieldView.canReuse(dto: field) {
            addedFieldView.setup(dto: field, inversed: false)
        } else {
            addedFieldView?.removeFromSuperview()

            let view = field.createField()
            (view as? InputFieldView)?.setup(dto: field, inversed: false)

            embed(view: view, inContainerView: inputContainerView)

            addedFieldView = view
        }
    }

    private func setup(suffix: InputBarButton?) {
        guard let suffix = suffix else {
            addedSuffixView?.removeFromSuperview()
            addedSuffixView = nil

            suffixContainerSizeConstaints.forEach({ $0.isActive = true })

            return
        }

        if let addedSuffixView = addedSuffixView, suffix.canReuse(view: addedSuffixView) {
            suffix.setupView(view: addedSuffixView)
        } else {
            let view = suffix.createView()
            embed(view: view, inContainerView: suffixContainerView)
            addedSuffixView = view
        }

        suffixContainerSizeConstaints.forEach({ $0.isActive = false })
    }

    private func setup(icon: Icon?) {
        guard let icon = icon else {
            addedIconView?.removeFromSuperview()
            addedIconView = nil

            iconContainerSizeConstaints.forEach({ $0.isActive = true })
            fieldToIconConstraint.constant = 0

            return
        }

        fieldToIconConstraint.constant = appearance.iconPadding
        
        if let addedIconView = addedIconView, icon.canReuse(view: addedIconView) {
            icon.setupView(view: addedIconView)
        } else {
            let view = icon.createView()
            embed(view: view, inContainerView: iconContainerView)
            addedIconView = view
        }

        iconContainerSizeConstaints.forEach({ $0.isActive = false })
    }

    private func setup(prefix: InputBarButton?) {
        guard let prefix = prefix else {
            addedPrefixView?.removeFromSuperview()
            addedPrefixView = nil

            prefixContainerSizeConstaints.forEach({ $0.isActive = true })

            return
        }

        if let addedPrefixView = addedPrefixView, prefix.canReuse(view: addedPrefixView) {
            prefix.setupView(view: addedPrefixView)
        } else {
            let view = prefix.createView()
            embed(view: view, inContainerView: prefixContainerView)
            addedPrefixView = view
        }

        prefixContainerSizeConstaints.forEach({ $0.isActive = false })
    }
}
