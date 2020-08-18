import VintedAPI
import VintedUI

protocol FeedInteractorInput {
    func load()
    func reload()
}

final class FeedInteractor {
    var presenter: FeedPresenterInput?
    private var items: [Item] = []
    private var page: Int = 0
}

extension FeedInteractor: FeedInteractorInput {
    func reload() {
        page = 0
        items = []
        load()
    }
    
    func load() {
        ItemsRoute(page: page).result { [weak self] result in
            switch result {
            case .success(let events):
               self?.didLoad(events)
            case .failure(let error):
               self?.didFailLoadingEvents(with: error)
            }
        }
        page += 1
    }
    
    private func didLoad(_ events: FeedEvents) {
        items += events.items
        let itemsToPresent = items
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.present(itemsToPresent)
        }
    }
    
    private func didFailLoadingEvents(with error: Error) {
        DispatchQueue.main.async {
            UIAlertController.alert(error)
        }
    }
}
