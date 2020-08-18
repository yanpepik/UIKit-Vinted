private let DynamicTypeDefaultsKey = "allow_dynamic_type"

public final class VintedUIConfiguration {
    public static let shared = VintedUIConfiguration()
    public var imageLoader: ImageLoader = DefaultImageLoader()
    public var shouldScaleFonts: Bool = UserDefaults.standard.bool(forKey: DynamicTypeDefaultsKey) {
        didSet {
            UserDefaults.standard.setValue(shouldScaleFonts, forKey: DynamicTypeDefaultsKey)
        }
    }
    
    private init() {}
}
