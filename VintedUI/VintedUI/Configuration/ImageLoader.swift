public protocol ImageDownloadReceipt {
    var identifier: UUID { get }
}

public protocol ImageLoader: AnyObject {
    @discardableResult
    func load(url: URL,
              receiptIdentifier: UUID,
              success: @escaping (UIImage) -> (),
              failure: ((Error) -> ())?) -> ImageDownloadReceipt?
    func cachedImaged(url: URL) -> UIImage?
    func cancelLoading(for receipt: ImageDownloadReceipt)
}

public class DefaultImageLoader: ImageLoader {
    private struct DownloadReceipt: ImageDownloadReceipt {
        let identifier: UUID
        let task: URLSessionDataTask
    }
    
    enum LoadingError: Error {
        case invalidResponse(URLResponse?)
        case invalidData(Data?)
    }
    
    private let session = URLSession.shared
    private var receipts: [UUID: URLSessionDataTask] = [:]
    private let backgroundQueue = DispatchQueue(label: "DefaultImageLoader")
    
    public init() {}
    
    public func load(url: URL,
                     receiptIdentifier: UUID = UUID(),
                     success: @escaping (UIImage) -> (),
                     failure: ((Error) -> ())?) -> ImageDownloadReceipt? {
        if let image = cachedImaged(url: url) {
            DispatchQueue.main.async {
                success(image)
            }
            return nil
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            self?.handleCompletion(
                for: receiptIdentifier,
                data: data,
                response: response,
                error: error,
                success: success,
                failure: failure
            )
        }
        backgroundQueue.sync {
            receipts[receiptIdentifier] = task
        }
        task.resume()
        return DownloadReceipt(identifier: receiptIdentifier, task: task)
    }
    
    private func handleCompletion(for ticket: UUID,
                                  data: Data?,
                                  response: URLResponse?,
                                  error: Error?,
                                  success: @escaping (UIImage) -> (),
                                  failure: ((Error) -> ())?) {
        backgroundQueue.sync {
            receipts[ticket] = nil
        }
            
        if let error = error {
            failure?(error)
            return
        }
        guard let data = data else {
            DispatchQueue.main.async {
                failure?(LoadingError.invalidResponse(response))
            }
            return
        }
        guard let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                failure?(LoadingError.invalidData(data))
            }
            return
        }
        DispatchQueue.main.async {
            success(image)
        }
    }
    
    public func cachedImaged(url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let data = session.configuration.urlCache?.cachedResponse(for: request)?.data else {
            return nil
        }
        return UIImage(data: data)
    }
    
    public func cancelLoading(for receipt: ImageDownloadReceipt) {
        backgroundQueue.sync {
            receipts[receipt.identifier]?.cancel()
            receipts[receipt.identifier] = nil
        }
    }
}
