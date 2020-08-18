public protocol LayoutGuideProvider {

    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuideProvider {}
extension UILayoutGuide: LayoutGuideProvider {}

public extension UIView {

    var compatibleSafeAreaLayoutGuide: LayoutGuideProvider {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return self
        }
    }
    
    func setupKeyboardAvoidingView(contentView: UIView, keyboardView: UIView) {
        layoutListContent(contentView: contentView)
        layoutKeyboardSpacerView(contentView: contentView, keyboardSpacerView: keyboardView)
    }
    
    private func layoutListContent(contentView: UIView) {
        addSubview(contentView)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.trailingAnchor),
            bottomConstraint
        ])
    }

    private func layoutKeyboardSpacerView(contentView: UIView, keyboardSpacerView: UIView) {
        addSubview(keyboardSpacerView)
        NSLayoutConstraint.activate([
            keyboardSpacerView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            keyboardSpacerView.bottomAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.bottomAnchor),
            keyboardSpacerView.leadingAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.leadingAnchor),
            keyboardSpacerView.trailingAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
