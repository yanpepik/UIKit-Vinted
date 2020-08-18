import UIKit

open class ViewController: UIViewController {
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let bundle = Bundle(for: type(of: self))
        let nibName = nibNameOrNil == nil ? String(describing: type(of: self)) : nibNameOrNil
        
        if bundle.path(forResource: nibName, ofType: "nib", inDirectory: nil, forLocalization: nil) != nil {
            super.init(nibName: nibName, bundle: bundle)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
       
        self.modalPresentationStyle = .fullScreen
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .fullScreen
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        edgesForExtendedLayout = []
    }
}
