extension NSURL: ImageSource {
    public var fullSizeRequest: ImageRequest {
        return Request(url: self as URL, imageLoader: VintedUIConfiguration.shared.imageLoader)
    }
    
    public func request(targetSize: CGSize, scaling: ImageScaling) -> ImageRequest {
        return fullSizeRequest
    }
    
    private final class Request: ImageRequest {
        private let url: URL
        private let imageLoader: ImageLoader
        private var requestReceipt: ImageDownloadReceipt?
        
        var identifier: String { return url.absoluteString }
        var cachedImage: UIImage? { return imageLoader.cachedImaged(url: url) }
        
        init(url: URL, imageLoader: ImageLoader) {
            self.url = url
            self.imageLoader = imageLoader
        }
        
        func perform(completion: @escaping ImageRequestCompletion) {
            if let cachedImage = cachedImage {
                completion(cachedImage)
                return
            }
            
            requestReceipt = imageLoader.load(
                url: url,
                receiptIdentifier: UUID(),
                success: { [weak self] image in
                    guard self?.requestReceipt != nil else { return }
                    completion(image)
                },
                failure: { [weak self] _ in
                    guard self?.requestReceipt != nil else { return }
                    completion(nil)
                }
            )
        }
        
        func cancel() {
            guard let requestReceipt = requestReceipt else {
                return
            }
            self.requestReceipt = nil
            imageLoader.cancelLoading(for: requestReceipt)
        }
    }
}
