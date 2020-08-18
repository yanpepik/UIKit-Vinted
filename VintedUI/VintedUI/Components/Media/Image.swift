@objc
public enum LabelStyle: Int {
    case normal
    case narrow
    case wide
    case tight

    var padding: CGFloat {
        switch self {
        case .normal:
            return 4.units
        case .narrow:
            return 2.units
        case .wide:
            return 6.units
        case .tight:
            return 0
        }
    }
}

public class Image: NSObject {
    let style: ImageStyle
    let scaling: ImageScaling
    let size: ImageSize
    let source: ImageSource?
    let loadingOptions: ImageLoadingOptions
    let label: String?
    let labelStyle: LabelStyle
    let backgroundColor: UIColor?
    let overrideColor: VintedColor?
    let onTap: ((UIImageView?) -> ())?
    let onImageLoad: (() -> ())?
    let accessibilityIdentifier: String?

    public init(source: ImageSource? = nil,
                loadingOptions: ImageLoadingOptions = ImageLoadingOptions(),
                size: ImageSize = ImageSize(iconSize: .regular) ,
                style: ImageStyle = ImageStyleDefault,
                scaling: ImageScaling = ImageScalingDefault,
                label: String? = nil,
                labelStyle: LabelStyle = .tight,
                backgroundColor: UIColor? = nil,
                overrideColor: VintedColor? = nil,
                accessibilityIdentifier: String? = nil,
                onTap: ((UIImageView?) -> ())? = nil,
                onImageLoad: (() -> ())? = nil) {
        self.style = style
        self.size = size
        self.scaling = scaling
        self.source = source
        self.label = label
        self.labelStyle = labelStyle
        self.backgroundColor = backgroundColor
        self.overrideColor = overrideColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.onTap = onTap
        self.onImageLoad = onImageLoad
        self.loadingOptions = loadingOptions
        super.init()
    }
    
    public convenience init(imageToLoad: LoadableImage? = nil,
                            size: ImageSize = ImageSize(iconSize: .regular) ,
                            style: ImageStyle = ImageStyleDefault,
                            scaling: ImageScaling = ImageScalingDefault,
                            label: String? = nil,
                            labelStyle: LabelStyle = .tight,
                            backgroundColor: UIColor? = nil,
                            overrideColor: VintedColor? = nil,
                            onTap: ((UIImageView?) -> ())? = nil,
                            onImageLoad: (() -> ())? = nil) {
        self.init(
            source: imageToLoad,
            loadingOptions: imageToLoad?.loadingOptions ?? ImageLoadingOptions(),
            size: size,
            style: style,
            scaling: scaling,
            label: label,
            labelStyle: labelStyle,
            backgroundColor: backgroundColor,
            overrideColor: overrideColor,
            accessibilityIdentifier: imageToLoad?.accessibilityIdentifier,
            onTap: onTap,
            onImageLoad: onImageLoad
        )
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(imageToLoad: LoadableImage?,
                            size: ImageSize,
                            style: ImageStyle,
                            scaling: ImageScaling,
                            label: String?,
                            labelStyle: LabelStyle = .tight,
                            backgroundColor: UIColor?,
                            onTap: ((UIImageView?) -> ())?) {
        self.init(
            imageToLoad: imageToLoad,
            size: size,
            style: style,
            scaling: scaling,
            label: label,
            labelStyle: labelStyle,
            backgroundColor: backgroundColor,
            onTap: onTap
        )
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(imageToLoad: LoadableImage?,
                            size: ImageSize,
                            style: ImageStyle,
                            scaling: ImageScaling,
                            label: String?,
                            labelStyle: LabelStyle = .tight,
                            backgroundColor: UIColor?,
                            onTap: ((UIImageView?) -> ())?,
                            onImageLoad: (() -> ())?) {
        self.init(
            imageToLoad: imageToLoad,
            size: size,
            style: style,
            scaling: scaling,
            label: label,
            labelStyle: labelStyle,
            backgroundColor: backgroundColor,
            onTap: onTap,
            onImageLoad: onImageLoad
        )
    }
    
    @objc 
    public convenience init(image: UIImage? = nil,
                            size: ImageSize = ImageSize(iconSize: .regular),
                            style: ImageStyle = ImageStyleDefault,
                            scaling: ImageScaling = ImageScalingDefault,
                            accessibilityIdentifier: String? = nil,
                            onTap: ((UIImageView?) -> ())? = nil) {
        var imageToLoad: LoadableImage?
        if let image = image {
            imageToLoad = LoadableImage(image: image, accessibilityIdentifier: accessibilityIdentifier)
        }

        self.init(imageToLoad: imageToLoad, size: size, style: style, scaling: scaling, onTap: onTap)
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(imageToLoad: LoadableImage?,
                            size: ImageSize = ImageSize(iconSize: .regular),
                            style: ImageStyle = ImageStyleDefault,
                            scaling: ImageScaling = ImageScalingDefault) {
        self.init(
            imageToLoad: imageToLoad,
            size: size,
            style: style,
            scaling: scaling
        )
    }
    
    // MARK: - Helpers
    
    @objc
    public static func circleImage(loadingDTO: LoadableImage, iconSize: IconSize, onTap: ((UIImageView?) -> ())? = nil) -> Image {
        return Image(
            imageToLoad: loadingDTO,
            size: ImageSize(iconSize: iconSize),
            style: .circle,
            scaling: .cover,
            onTap: onTap
        )
    }
    
    @objc
    public static func extraLargeCircleImage(loadingDTO: LoadableImage, onTap: ((UIImageView?) -> ())?) -> Image {
        return Image(
            imageToLoad: loadingDTO,
            size: ImageSize(iconSize: .large),
            style: .circle,
            scaling: .cover,
            onTap: onTap
        )
    }
    
    @objc 
    public static func imageDTO(loadingDTO: LoadableImage, iconSize: IconSize, style: ImageStyle, scaling: ImageScaling) -> Image {
        return Image(
            imageToLoad: loadingDTO,
            size: ImageSize(iconSize: iconSize),
            style: style,
            scaling: scaling
        )
    }
}

extension Image: ViewData {
    public func createView() -> UIView {
        let view = ImageView()
        setupView(view: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is ImageView
    }

    public func setupView(view: UIView) {
        (view as? ImageView)?.setup(dto: self)
    }
}
