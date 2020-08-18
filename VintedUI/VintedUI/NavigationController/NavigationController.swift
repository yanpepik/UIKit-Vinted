import UIKit

public class NavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .fullScreen
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .fullScreen
    }
    
    deinit {
        delegate = nil
    }
    
    public override var shouldAutorotate: Bool {
        return viewControllers.last?.shouldAutorotate ?? false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewControllers.last?.supportedInterfaceOrientations ?? [.portrait]
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
