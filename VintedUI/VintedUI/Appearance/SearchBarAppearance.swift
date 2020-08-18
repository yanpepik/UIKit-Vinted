@objc
public protocol SearchBarAppearance: AnyObject {
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var searchTextAttributes: [NSAttributedString.Key: Any] { get }
    var placeholderTextAttributes: [NSAttributedString.Key: Any] { get }
    var textFieldBackground: UIColor { get }
    var searchIcon: UIImage? { get }
    var clearIcon: UIImage? { get }
}

public final class VintedSearchBarAppearance: NSObject, SearchBarAppearance {
    public let backgroundColor = Color(.grayscale9)
    public let tintColor = Color(.grayscale4)
    public let searchTextAttributes = textAttributes(type: .body, ignoreLineSpacing: true)
    public let placeholderTextAttributes = textAttributes(
        type: .body,
        theme: .muted,
        ignoreLineSpacing: true,
        alpha: AlphaEnabled,
        lineBreakMode: .byTruncatingTail
    )
    public let textFieldBackground = Color(.grayscale8)
    public var searchIcon: UIImage? {
        return UIImage(named: "searchFieldIcon", in: Bundle(for: VintedSearchBarAppearance.self), compatibleWith: nil)?.with(tintColor: tintColor)
    }
    public var clearIcon: UIImage? {
        return UIImage(named: "searchFieldClearIcon", in: Bundle(for: VintedSearchBarAppearance.self), compatibleWith: nil)?.with(tintColor: tintColor)
    }

    @objc
    public func apply(to searchBar: UISearchBar, placeholder: String) {
        applyBackgroundAppearance(to: searchBar)
        applyIconsAppearance(to: searchBar)
        applyBarButtonAppearance()
        applySearchTextAttributes()
        applyTextFieldAppearance(to: searchBar, with: placeholder)
    }

    private func applyBackgroundAppearance(to searchBar: UISearchBar) {
        searchBar.tintColor = tintColor
        searchBar.backgroundColor = backgroundColor
        searchBar.isTranslucent = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
    }

    private func applyIconsAppearance(to searchBar: UISearchBar) {
        searchBar.setImage(clearIcon, for: UISearchBar.Icon.clear, state: .normal)
        searchBar.setImage(clearIcon, for: UISearchBar.Icon.clear, state: .highlighted)
        searchBar.setImage(clearIcon, for: UISearchBar.Icon.clear, state: .selected)

        searchBar.setImage(searchIcon, for: UISearchBar.Icon.search, state: .normal)
        searchBar.setImage(searchIcon, for: UISearchBar.Icon.search, state: .highlighted)
    }

    private func applyBarButtonAppearance() {
        NavBarButtonItemAppearance().apply(for: UISearchBar.self)
    }

    private func applySearchTextAttributes() {
        let appearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        appearance.defaultTextAttributes = searchTextAttributes
    }

    private func applyTextFieldAppearance(to searchBar: UISearchBar, with placeholder: String) {
        guard let searchBarTextField = searchBar.textField else { return }

        if !placeholder.isEmpty {
            searchBarTextField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: placeholderTextAttributes
            )
        }
        searchBarTextField.tintColor = tintColor

        let leftImageView = searchBarTextField.leftView
        leftImageView?.contentMode = UIView.ContentMode.center
    }
}

private extension UISearchBar {

    var textField: UITextField? {
        guard #available(iOS 13.0, *) else {
            return value(forKey: "_searchField") as? UITextField
        }
        return searchTextField
    }
}

private extension UIImage {

    func with(tintColor: UIColor) -> UIImage? {
        guard #available(iOS 13.0, *) else { return maskWithColor(color: tintColor) }
        return withTintColor(tintColor, renderingMode: .alwaysTemplate)
    }

    private func maskWithColor(color: UIColor) -> UIImage? {
        guard let maskImage = cgImage else { return nil }

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else { return nil }

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        guard let cgImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
