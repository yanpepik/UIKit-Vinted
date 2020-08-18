import UIKit

public let ItemGridDefaultSectionInset = CGFloat(10.0)

public class AppAppearance: NSObject {
    @objc
    public static let shared = AppAppearance()
    public var navigationBarAppearance = NavigationBarAppearance()
    private(set) var searchBarAppearance = VintedSearchBarAppearance()

    class func setGlobalNavBarAppearance() {
        AppAppearance.shared.setGlobalNavBarAppearance()
    }

    public func setGlobalNavBarAppearance() {
        navigationBarAppearance.apply()
    }

    public func setComposerNavBarAppearance() {
        UINavigationBar.appearance().barTintColor = nil
        UINavigationBar.appearance().tintColor = nil

        UINavigationBar.appearance().titleTextAttributes = nil
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .disabled)
    }

    private func setSwitch() {
        UISwitch.appearance().onTintColor = Color(.secondary1)
    }

    private func setupToolbarAppearance() {
        let backgroundColor = Color(.grayscale9)
        let backgroundImageFromColor = UIImage.imageFromColor(
            fromColor: backgroundColor,
            with: CGSize(width: 1, height: 1)
        )
        UIToolbar.appearance().backgroundColor = backgroundColor
        UIToolbar.appearance().setBackgroundImage(
            backgroundImageFromColor,
            forToolbarPosition: .any,
            barMetrics: .default
        )
    }

    public func setupAppearance() {
        setGlobalNavBarAppearance()
        setupToolbarAppearance()

        UIDatePicker.appearance().backgroundColor = Color(.grayscale9)

        setSwitch()
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).showsTouchWhenHighlighted(fromBoolNumber: false)
        UIButton.appearance(whenContainedInInstancesOf: [UISearchBar.self]).showsTouchWhenHighlighted(fromBoolNumber: false)
        UIButton.appearance().setExclusiveTouchFromBoolNumber(true)

        // TabBar appearance
        UITabBar.appearance().tintColor = Color(.primary1)
        UITabBar.appearance().unselectedItemTintColor = Color(.grayscale3)

        UITabBar.appearance().barTintColor = Color(.grayscale9)
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: FontMedium(12, allowScaling: false),
                NSAttributedString.Key.foregroundColor: Color(.grayscale3)
            ],
            for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: FontMedium(12, allowScaling: false),
                NSAttributedString.Key.foregroundColor: Color(.primary1)
            ],
            for: .selected
        )

        setupUITableViewAppearance()
        setupTabbarBadgeAppearance()
        
        setupAutomaticFontSizeAdjustment()
    }

    @objc
    public func applySearchStyle(to searchBar: UISearchBar, placeholder: String) {
        searchBarAppearance.apply(to: searchBar, placeholder: placeholder)
    }

    @objc
    public func applySearchStyle(to searchBar: UISearchBar) {
        applySearchStyle(to: searchBar, placeholder: "Search")
    }

    private func setupAutomaticFontSizeAdjustment() {
        UILabel.appearance().adjustsFontForContentSizeCategory = true
        UITextField.appearance().adjustsFontForContentSizeCategory = true
        UITextView.appearance().adjustsFontForContentSizeCategory = true
    }

    private func setupTabbarBadgeAppearance() {
        UITabBarItem.appearance().badgeColor = Color(.secondary3)
    }

    private func setupUITableViewAppearance() {
        UITableView.appearance().separatorColor = Color(.grayscale6)
    }
}
