public final class CommonAppearance: NSObject, VintedAppearance {
    public var viewControllerBackgroundColor: UIColor {
        return Color(.grayscale8)
    }
    
    public var tableViewBackgroundColor: UIColor {
        return Color(.grayscale8)
    }
    
    public var collectionViewBackgroundColor: UIColor {
        return Color(.grayscale8)
    }
    
    public var tableViewSeparatorStyle: UITableViewCell.SeparatorStyle {
        return .none
    }
}
