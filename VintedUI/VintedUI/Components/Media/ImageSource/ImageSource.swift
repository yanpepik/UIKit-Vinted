public typealias ImageRequestCompletion = (UIImage?) -> ()

@objc
public protocol ImageSource {
    var fullSizeRequest: ImageRequest { get }
    func request(targetSize: CGSize, scaling: ImageScaling) -> ImageRequest
}

@objc
public protocol ImageRequest {
    var identifier: String { get }
    var cachedImage: UIImage? { get }
    func perform(completion: @escaping ImageRequestCompletion)
    func cancel()
}
