import VintedAPI

protocol FeedPresenterInput {
    func present(_ items: [Item])
}

final class FeedPresenter {
    var viewController: FeedViewControllerInput?
}

extension FeedPresenter: FeedPresenterInput {
    func present(_ items: [Item]) {
        viewController?.display(items)
    }
}
