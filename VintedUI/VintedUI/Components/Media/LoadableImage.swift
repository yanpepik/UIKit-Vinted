public class LoadableImage: NSObject {
    let url: URL?
    let image: UIImage?
    public let placeholder: UIImage?
    let animated: Bool
    let fade: Bool
    let loader: ImageLoader
    let accessibilityIdentifier: String?
    
    @objc
    public init(image: UIImage, accessibilityIdentifier: String? = nil) {
        self.image = image
        self.url = nil
        self.placeholder = nil
        self.animated = false
        self.fade = false
        self.loader = VintedUIConfiguration.shared.imageLoader
        self.accessibilityIdentifier = accessibilityIdentifier
        super.init()
    }

    public init(url: URL?,
                placeholder: UIImage? = nil,
                animated: Bool = true,
                fade: Bool = true,
                loader: ImageLoader = VintedUIConfiguration.shared.imageLoader,
                accessibilityIdentifier: String? = nil) {
        self.url = url
        self.image = nil
        self.placeholder = placeholder
        self.animated = animated
        self.fade = fade
        self.loader = loader
        self.accessibilityIdentifier = accessibilityIdentifier
        super.init()
    }

    @objc
    @available(swift, obsoleted: 3.0)
    convenience public init(url: URL?, placeholder: UIImage?, animated: Bool, fade: Bool) {
        self.init(url: url, placeholder: placeholder, animated: animated, fade: fade, loader: VintedUIConfiguration.shared.imageLoader)
    }

    @objc
    @available(swift, obsoleted: 3.0)
    convenience public init(url: URL?, placeholder: UIImage?) {
        self.init(url: url, placeholder: placeholder, animated: true, fade: true, loader: VintedUIConfiguration.shared.imageLoader)
    }
}

extension LoadableImage: ImageSource {
    public func request(targetSize: CGSize, scaling: ImageScaling) -> ImageRequest {
        if let image = image {
            return image.request(targetSize: targetSize, scaling: scaling)
        } else if let url = url {
            return (url as NSURL).request(targetSize: targetSize, scaling: scaling)
        }
        return EmptyImageRequest()
    }
    
    public var fullSizeRequest: ImageRequest {
        if let image = image {
            return image.fullSizeRequest
        } else if let url = url {
            return (url as NSURL).fullSizeRequest
        }
        return EmptyImageRequest()
    }
    
    private class EmptyImageRequest: ImageRequest {
        let identifier: String = "EmptyImageRequest"
        
        let cachedImage: UIImage? = nil
        
        func perform(completion: @escaping ImageRequestCompletion) {
            completion(nil)
        }
        
        func cancel() {}
    }
}

extension LoadableImage {
    var loadingOptions: ImageLoadingOptions {
        return ImageLoadingOptions(placeholder: placeholder, showSpinner: animated, useFadeAnimation: fade)
    }
}
