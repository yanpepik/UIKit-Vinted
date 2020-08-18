import VintedUI
import VintedAPI

protocol FeedViewControllerInput: class {
    func display(_ items: [Item])
}

final class FeedViewController: ViewController {
    enum FeedCell {
        case item(Item)
        case noItems
    }
    
    @IBOutlet
    private var collectionView: UICollectionView!
    private var interactor: FeedInteractorInput!
    private var cells: [FeedCell] = []
    var isLoading = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
  // MARK: - Setup
  
    private func setup() {
        let viewController = self
        let interactor = FeedInteractor()
        let presenter = FeedPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
  // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        displaySearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor.load()
    }
    
    private func setupCollectionView() {
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        let refreshControl = RefreshControl()
        refreshControl.onRefresh = interactor.reload
        collectionView.refreshControl = refreshControl
    }
    
    private func emptyState() -> Cell {
        FeedUIBuilder.noResult()
    }
    
    private func itemCell(item: Item) -> Cell {
        FeedUIBuilder.itemBox(
            item: item,
            onImageLoad: {},
            onTap: {}
        )
    }
    
    private func displaySearchBar() {
        let text: String? = nil
        var clearButton: InputBarButton?
        
        if text?.isEmpty == false {
            clearButton = InputBarButton(
                icon: UIImage(named: "searchBarClearIcon"),
                accessibilityIdentifier: "clear",
                onTap: {}
            )
        }
        
        let searchBar = InputBar(
            inputField: TextField(
                value: text,
                placeholder: __("search"),
                formatter: TextFieldFormatter(returnKeyType: .search),
                editingChanged: nil,
                onReturn: nil
            ),
            suffix: clearButton,
            icon: Icon(image: UIImage(named: "searchBarSearchIcon"), size: .small, color: .grayscale4)
        )
        
        if let view = navigationItem.titleView, searchBar.canReuse(view: view) {
            searchBar.setupView(view: view)
        } else {
            navigationItem.titleView = searchBar.createView()
        }
    }
}

extension FeedViewController: FeedViewControllerInput {
    
    func display(_ items: [Item]) {
        if items.isEmpty {
            cells = [.noItems]
        } else {
            cells = []
            for item in items {
                cells.append(.item(item))
            }
        }
        collectionView.reloadData()
        isLoading = false
        collectionView.refreshControl?.endRefreshing()
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let data: ViewData
        switch cells[indexPath.row] {
        case .item(let item):
            data = itemCell(item: item)
        case .noItems:
            data = emptyState()
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
            isLoading = true
            interactor.load()
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cells[indexPath.row] {
        case .item:
            let width = (collectionView.frame.size.width - SpacerSize.small.floatValue) / 2
            return CGSize(
                width: width,
                height: width * 1.9
            )
        case .noItems:
            return collectionView.bounds.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
