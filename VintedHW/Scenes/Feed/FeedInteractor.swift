import VintedAPI
import VintedUI

protocol FeedBusinessLogic: AnyObject {
    func fetchInitialData(request: Feed.InitialData.Request)
    func fetchReloadedData(request: Feed.ReloadedData.Request)
    func fetchFilteredData(request: Feed.FilteredData.Request)
    func sendAnalytics(request: Feed.Analytics.Request)
}

final class FeedInteractor {
    // MARK: - Private Properties
    private let presenter: FeedPresentationLogic
    private var items: [Item] = []
    private var page: Int = 0
    private var currentKeywoard: String = ""
    private var currentTask: URLSessionTask?

    // MARK: - Initialization
    init(presenter: FeedPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - FeedBusinessLogic
extension FeedInteractor: FeedBusinessLogic {
    func fetchInitialData(request: Feed.InitialData.Request) {
        requestItems { [weak self] result in
            self?.presenter.presentInitialData(response: Feed.InitialData.Response(feedResult: result))
        }
    }

    func fetchReloadedData(request: Feed.ReloadedData.Request) {
        resetPagination()
        requestItems { [weak self] result in
            self?.presenter.presentReloadedData(response: Feed.ReloadedData.Response(feedResult: result))
        }
    }

    func fetchFilteredData(request: Feed.FilteredData.Request) {
        if currentKeywoard != request.keywoard {
            resetPagination()
        }
        currentKeywoard = request.keywoard
        requestItems(keywoard: request.keywoard) { [weak self] result in
            self?.presenter.presentFilteredData(response: Feed.FilteredData.Response(feedResult: result))
        }
    }

    func sendAnalytics(request: Feed.Analytics.Request) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let params = AnalyticsRoute.Params(items: [AnalyticsRoute.Params.Item(id: request.id, timestamp: timestamp)])
        AnalyticsRoute(params: params).result { result in
            print(result)
        }
    }

    private func resetPagination() {
        page = 0
        items = []
    }

    private func requestItems(keywoard: String? = nil, completion: @escaping (Feed.FeedResponseResult) -> Void) {
        currentTask?.cancel()
        let params = ItemsRoute.Params(page: page, search_text: keywoard)
        currentTask = ItemsRoute(params: params).result { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let events):
                self.items.append(contentsOf: events.items ?? [])
                let items = self.items.map { item in
                    Feed.FeedResponseResult.FeedItemResponse(
                        id: item.id,
                        imageURL: item.image,
                        price: item.price,
                        brand: item.brand,
                        category: item.category
                    )
                }
                page += 1
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            case .failure(let error as NSError):
                if error.domain == NSURLErrorDomain, error.code != NSURLErrorCancelled {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
