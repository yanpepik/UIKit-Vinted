import VintedAPI

protocol FeedPresentationLogic: AnyObject {
    func presentInitialData(response: Feed.InitialData.Response)
    func presentReloadedData(response: Feed.ReloadedData.Response)
    func presentFilteredData(response: Feed.FilteredData.Response)
}

final class FeedPresenter {
    // MARK: - Properties
    weak var viewController: FeedDisplayLogic?
}

// MARK: - FeedPresentationLogic
extension FeedPresenter: FeedPresentationLogic {
    func presentInitialData(response: Feed.InitialData.Response) {
        let itemsViewModelResult = createItemsViewModelResult(responseResult: response.feedResult)
        let viewModel = Feed.InitialData.ViewModel(feedResult: itemsViewModelResult)
        viewController?.displayInitialData(viewModel: viewModel)
    }

    func presentReloadedData(response: Feed.ReloadedData.Response) {
        let itemsViewModelResult = createItemsViewModelResult(responseResult: response.feedResult)
        let viewModel = Feed.ReloadedData.ViewModel(feedResult: itemsViewModelResult)
        viewController?.displayReloaedData(viewModel: viewModel)
    }

    func presentFilteredData(response: Feed.FilteredData.Response) {
        let itemsViewModelResult = createItemsViewModelResult(responseResult: response.feedResult)
        let viewModel = Feed.FilteredData.ViewModel(feedResult: itemsViewModelResult)
        viewController?.displayFilteredData(viewModel: viewModel)
    }

    private func createItemsViewModelResult(responseResult: Feed.FeedResponseResult) -> Feed.FeedViewModelResult {
        switch responseResult {
        case .success(let responseItems):
            let viewModelItems = responseItems.map { item in
                Feed.FeedViewModelResult.FeedItemViewModel(
                    id: item.id,
                    imageURL: item.imageURL,
                    priceText: "\(item.price) €",
                    brand: item.brand,
                    category: item.category
                )
            }
            return .success(viewModelItems)
        case .failure(let error):
            return .failure(error)
        }
    }
}
