import UIKit

enum Feed {
    enum InitialData {
        struct Request {}

        struct Response {
            let feedResult: FeedResponseResult
        }

        struct ViewModel {
            let feedResult: FeedViewModelResult
        }
    }

    enum ReloadedData {
        struct Request {}

        struct Response {
            let feedResult: FeedResponseResult
        }

        struct ViewModel {
            let feedResult: FeedViewModelResult
        }
    }

    enum FilteredData {
        struct Request {
            let keywoard: String
        }

        struct Response {
            let feedResult: FeedResponseResult
        }

        struct ViewModel {
            let feedResult: FeedViewModelResult
        }
    }
}

extension Feed {
    enum FeedResponseResult {
        case success([FeedItemResponse])
        case failure(Error)

        struct FeedItemResponse {
            let id: Int
            let imageURL: URL?
            let price: Decimal
            let brand: String
            let category: String
        }
    }

    enum FeedViewModelResult {
        case success([FeedItemViewModel])
        case failure(Error)

        struct FeedItemViewModel {
            let id: Int
            let imageURL: URL?
            let priceText: String
            let brand: String
            let category: String
        }
    }
}
