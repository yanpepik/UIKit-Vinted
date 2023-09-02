import UIKit

enum FeedAssembly {
    static func assemble() -> UIViewController {
        let presenter = FeedPresenter()
        let interactor = FeedInteractor(presenter: presenter)
        let viewController = FeedViewController(interactor: interactor)

        presenter.viewController = viewController

        return viewController
    }
}
