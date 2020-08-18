@objc
public enum LoaderSize: Int {
    case small
    case medium
    case `default`
    case large
    case xLarge
    case xxLarge
    case xxxLarge

    public var size: CGSize {
        switch self {
        case .small:
            return CGSize(width: 3.units, height: 3.units)
        case .medium:
            return CGSize(width: 4.units, height: 4.units)
        case .default:
            return CGSize(width: 6.units, height: 6.units)
        case .large:
            return CGSize(width: 8.units, height: 8.units)
        case .xLarge:
            return CGSize(width: 12.units, height: 12.units)
        case .xxLarge:
            return CGSize(width: 18.units, height: 18.units)
        case .xxxLarge:
            return CGSize(width: 24.units, height: 24.units)
        }
    }

    public var padding: CGFloat {
        switch self {
        case .small, .medium:
            return 0.25.units
        case .default, .large:
            return 0.5.units
        case .xLarge:
            return 1.units
        case .xxLarge:
            return 1.5.units
        case .xxxLarge:
            return 2.units
        }
    }

    public var lineWidth: CGFloat {
        switch self {
        case .small, .medium, .default:
            return 0.5.units
        case .large:
            return 0.75.units
        case .xLarge:
            return 1.units
        case .xxLarge:
            return 1.25.units
        case .xxxLarge:
            return 2.units
        }
    }
}

@objc
public enum LoaderState: Int {
    case loading
    case success
    case failure
    
    var image: UIImage? {
        switch self {
        case .loading:
            return nil
        case .success:
            return asset(named: "loaderSuccess")
        case .failure:
            return asset(named: "loaderFailure")
        }
    }
}

public class Loader: NSObject {
    let state: LoaderState
    let size: LoaderSize
    let theme: VintedTheme?
    
    public init(state: LoaderState = .loading, size: LoaderSize = .xLarge, theme: VintedTheme? = nil) {
        self.state = state
        self.size = size
        self.theme = theme
        super.init()
    }
}

extension Loader: ViewData {
    public func createView() -> UIView {
        let view = LoaderView()
        setupView(view: view)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is LoaderView
    }

    public func setupView(view: UIView) {
        (view as? LoaderView)?.setup(loader: self)
    }
}
