extension UIImage: ImageSource {
    public var fullSizeRequest: ImageRequest {
        return request(targetSize: size, scaling: .fill)
    }
    
    public func request(targetSize: CGSize, scaling: ImageScaling) -> ImageRequest {
        return Request(image: self)
    }
}

private extension UIImage {
    final class Request: ImageRequest {
        let identifier: String = UUID().uuidString
        private let image: UIImage
        
        var cachedImage: UIImage? { return image }
        
        init(image: UIImage) {
            self.image = image
        }
        
        func perform(completion: @escaping ImageRequestCompletion) {
            completion(image)
        }
        
        func cancel() {}
    }
}
