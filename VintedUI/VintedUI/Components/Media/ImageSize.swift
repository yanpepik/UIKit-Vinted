@objc public enum ImageSizeType: Int {
    case auto
    case percentage
    case unit
}

let DefaultImageSize = ImageSize(iconSize: .regular)

public class ImageSize: NSObject {
    public static let defaultValue = DefaultImageSize
    
    public let widthSize: ImageSizeType
    public let width: CGFloat
    public let heightSize: ImageSizeType
    public let height: CGFloat
    public let ratio: ImageRatio
    
    @objc
    public init(iconSize: IconSize) {
        self.heightSize = .unit
        self.widthSize = .unit
        self.width = iconSize.size.width
        self.height = iconSize.size.height
        self.ratio = .square
        super.init()
    }
    
    @objc
    public init(widthSize: ImageSizeType, width: CGFloat, heightSize: ImageSizeType, height: CGFloat, ratio: ImageRatio = ImageRatioDefault) {
        self.heightSize = heightSize
        self.height = height
        self.widthSize = widthSize
        self.width = width
        self.ratio = ratio
        super.init()
    }
    
    public convenience init(image: UIImage) {
        self.init(widthSize: .unit, width: image.size.width, heightSize: .unit, height: image.size.height)
    }
    
    @objc
    public class func chatSize(forWidth screenWidth: CGFloat) -> ImageSize {
        let width = min(screenWidth - 34.units, 96.units)
        return ImageSize(
            widthSize: .unit,
            width: width,
            heightSize: .unit,
            height: width * ImageRatio.portrait.widthToHeightRatio,
            ratio: .portrait
        )
    }
}

extension ImageSize {
    public convenience init(size: CGSize) {
        self.init(widthSize: .unit, width: size.width, heightSize: .unit, height: size.height)
    }
}
