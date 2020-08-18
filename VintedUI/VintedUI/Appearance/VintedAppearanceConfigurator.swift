@objc
public protocol VintedAppearance {
    var viewControllerBackgroundColor: UIColor { get }
    var tableViewBackgroundColor: UIColor { get }
    var collectionViewBackgroundColor: UIColor { get }
    var tableViewSeparatorStyle: UITableViewCell.SeparatorStyle { get }
}

public final class VintedAppearanceConfigurator: NSObject {
    @objc
    class public func setup(appearance: VintedAppearance, tableView: UITableView?, viewController: UIViewController) {
        viewController.view.backgroundColor = appearance.viewControllerBackgroundColor
        tableView?.backgroundColor = appearance.tableViewBackgroundColor
        tableView?.separatorStyle = appearance.tableViewSeparatorStyle
    }
    
    @objc
    class public func setup(appearance: VintedAppearance, collectionView: UICollectionView?, viewController: UIViewController) {
        viewController.view.backgroundColor = appearance.viewControllerBackgroundColor
        collectionView?.backgroundColor = appearance.collectionViewBackgroundColor
    }

    static public func setup(appearance: VintedAppearance, viewController: UIViewController) {
        viewController.view.backgroundColor = appearance.viewControllerBackgroundColor
    }
}
