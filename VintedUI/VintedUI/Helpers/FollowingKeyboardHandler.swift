public class FollowingKeyboardHandler: NSObject {

    @objc
    public var onFollow: ((_ keyboardHeight: CGFloat) -> ())?

    @objc
    var bottomConstraint: NSLayoutConstraint?

    @objc
    var view: UIView?

    @objc
    public func followKeyboard(view: UIView, bottomConstraint: NSLayoutConstraint) {
        self.view = view
        self.bottomConstraint = bottomConstraint
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillUpdateNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillUpdateNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillUpdateNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc
    public func stopFollowingKeyboard() {
        NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
    }

    @objc
    func handleKeyboardWillUpdateNotification(_ notification: Foundation.Notification) {
        guard
            let bottomConstraint = bottomConstraint,
            let view = view,
            let keyWindow = VintedUI.ConfigurationManager.shared.configuration.windowProvider.window,
            let userInfo = (notification as NSNotification).userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        var keyboardHeight = max(keyWindow.height - frame.origin.y, 0)
        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardHeight = 0
        }
        bottomConstraint.constant = keyboardHeight
        view.layoutIfNeeded()
        onFollow?(keyboardHeight)
    }
}
