import VintedUI
import VintedAPI

protocol FeedDisplayLogic: AnyObject {
    func displayInitialData(viewModel: Feed.InitialData.ViewModel)
    func displayReloaedData(viewModel: Feed.ReloadedData.ViewModel)
    func displayFilteredData(viewModel: Feed.FilteredData.ViewModel)
}

final class FeedViewController: ViewController {
    // MARK: - Properties
    private let interactor: FeedBusinessLogic
    private var items: [Feed.FeedViewModelResult.FeedItemViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var isLoading = false
    private var isPaginationLoading = false

    // MARK: - UI Properties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        let refreshControl = RefreshControl()
        refreshControl.onRefresh = { [weak self] in
            guard let self, let searchText = searchController.searchBar.text else { return }
            if searchText.isEmpty {
                self.interactor.fetchReloadedData(request: Feed.ReloadedData.Request())
            } else {
                self.interactor.fetchFilteredData(request: Feed.FilteredData.Request(keywoard: searchText))
            }
        }
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()

    // MARK: - Initialization
    init(interactor: FeedBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in FeedViewController")
    }
    
  // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchInitialData()
    }

    // MARK: - Private Methods
    private func setupNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSubviews() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchInitialData() {
        collectionView.refreshControl?.beginRefreshing()
        interactor.fetchInitialData(request: Feed.InitialData.Request())
    }

    private func createEmptyCell() -> Cell {
        FeedUIBuilder.noResult()
    }

    private func createItemCell(item: Feed.FeedViewModelResult.FeedItemViewModel) -> Cell {
        FeedUIBuilder.itemBox(
            item: item,
            onImageLoad: { [weak self] in
                let request = Feed.Analytics.Request(id: item.id)
                self?.interactor.sendAnalytics(request: request)
            },
            onTap: {}
        )
    }
}

// MARK: - CollectionView DataSource & Delegate
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count == 0 ? 1 : items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let data: ViewData

        if !items.isEmpty {
            data = createItemCell(item: items[indexPath.row])
        } else {
            data = createEmptyCell()
        }

        (cell as? CollectionViewCell)?.setup(Cell(body: data, size: .tight))
        return cell
    }
}

extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else {
            return
        }
        if (scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y < scrollView.frame.size.height) {
            guard let searchText = searchController.searchBar.text else { return }
            isLoading = true
            isPaginationLoading = true
            if searchText.isEmpty {
                interactor.fetchInitialData(request: Feed.InitialData.Request())
            } else {
                interactor.fetchFilteredData(request: Feed.FilteredData.Request(keywoard: searchText))
            }
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if !items.isEmpty {
            let width = (collectionView.frame.size.width - SpacerSize.small.floatValue) / 2
            return CGSize(
                width: width,
                height: width * 1.9
            )
        }

        return collectionView.bounds.size
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - FeedDisplayLogic
extension FeedViewController: FeedDisplayLogic {
    func displayInitialData(viewModel: Feed.InitialData.ViewModel) {
        displayItems(feedResult: viewModel.feedResult)
    }

    func displayReloaedData(viewModel: Feed.ReloadedData.ViewModel) {
        displayItems(feedResult: viewModel.feedResult)
    }

    func displayFilteredData(viewModel: Feed.FilteredData.ViewModel) {
        displayItems(feedResult: viewModel.feedResult)
    }

    private func displayItems(feedResult: Feed.FeedViewModelResult) {
        switch feedResult {
        case .success(let items):
            self.items = items
        case .failure(let error):
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        }
        isLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.collectionView.refreshControl?.endRefreshing()
            if !self.isPaginationLoading {
                self.collectionView.setContentOffset(.zero, animated: true)
            }
            self.isPaginationLoading = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        collectionView.refreshControl?.beginRefreshing()
        collectionView.setContentOffset(
            CGPoint(x: 0, y: -(collectionView.refreshControl?.frame.size.height ?? 0)),
            animated: true
        )
        interactor.fetchFilteredData(request: Feed.FilteredData.Request(keywoard: text))
    }
}
