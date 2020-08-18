@objc
public enum IconSize: Int {
    case xSmall
    case small
    case regular
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    case xxxxLarge

    public var size: CGSize {
        switch self {
        case .xSmall:
            return CGSize(width: 3.units, height: 3.units)
        case .small:
            return CGSize(width: 4.units, height: 4.units)
        case .regular:
            return CGSize(width: 6.units, height: 6.units)
        case .medium:
            return CGSize(width: 8.units, height: 8.units)
        case .large:
            return CGSize(width: 12.units, height: 12.units)
        case .xLarge:
            return CGSize(width: 16.units, height: 16.units)
        case .xxLarge:
            return CGSize(width: 24.units, height: 24.units)
        case .xxxLarge:
            return CGSize(width: 32.units, height: 32.units)
        case .xxxxLarge:
            return CGSize(width: 48.units, height: 48.units)
        }
    }
}

public class Icon: NSObject {
    let loadableImage: LoadableImage?
    let size: IconSize
    let color: VintedColor?
    let accessabilityIdentifier: String?
    let onTap: (() -> ())?

    public init(loadableImage: LoadableImage?,
                size: IconSize = .regular,
                color: VintedColor? = nil,
                accessabilityIdentifier: String? = nil,
                onTap: (() -> ())? = nil) {

        self.loadableImage = loadableImage
        self.size = size
        self.color = color
        self.onTap = onTap
        self.accessabilityIdentifier = accessabilityIdentifier ?? loadableImage?.accessibilityIdentifier
        super.init()
    }

    public convenience init(image: UIImage? = nil,
                            size: IconSize = .regular,
                            color: VintedColor? = nil,
                            accessabilityIdentifier: String? = nil,
                            onTap: (() -> ())? = nil) {

        self.init(
            loadableImage: image.map { LoadableImage(image: $0) },
            size: size,
            color: color,
            accessabilityIdentifier: accessabilityIdentifier,
            onTap: onTap
        )
    }

    @objc
    public convenience init(image: UIImage? = nil,
                            size: IconSize = .regular,
                            accessabilityIdentifier: String? = nil,
                            onTap: (() -> ())? = nil) {
        self.init(
            image: image,
            size: size,
            color: nil,
            accessabilityIdentifier: accessabilityIdentifier,
            onTap: onTap
        )
    }
}

extension Icon: ViewData {
    public func createView() -> UIView {
        let view = IconView()
        setupView(view: view)
        return view
        
    }

    public func canReuse(view: UIView) -> Bool {
        return view is IconView
    }

    public func setupView(view: UIView) {
        (view as? IconView)?.setup(dto: self)
    }
}

// MARK: - Obj-c helpers

extension Icon {
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(image: UIImage?, size: IconSize) {
        self.init(image: image, size: size, onTap: nil)
    }
}
