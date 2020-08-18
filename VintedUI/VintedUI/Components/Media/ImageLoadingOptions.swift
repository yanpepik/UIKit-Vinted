@objc
public class ImageLoadingOptions: NSObject {
    let placeholder: UIImage?
    let showSpinner: Bool
    let useFadeAnimation: Bool
    
    public init(placeholder: UIImage? = nil, showSpinner: Bool = false, useFadeAnimation: Bool = false) {
        self.placeholder = placeholder
        self.showSpinner = showSpinner
        self.useFadeAnimation = useFadeAnimation
        super.init()
    }
}
