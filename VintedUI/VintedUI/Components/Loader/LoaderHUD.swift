import UIKit

let LoaderPresentationFadeInDuration: TimeInterval = 0.35
private let padding = 4.units

public final class LoaderHUD: UIViewController {
    public static let displayDuration: Double = 0.5
    @objc public static var isVisible: Bool { return shared.view.superview != nil }
    private static let shared = LoaderHUD()

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var verticalCenteringConstraint: NSLayoutConstraint!

    private let loaderView = LoaderView()

    // MARK: - Static

    @objc
    public static func show(_ state: LoaderState = .loading) {
        shared.loaderView.setup(loader: Loader(state: state, size: .xLarge, theme: .primary))
        shared.fadeInLoader()
        performHapticFeedbackIfNeeded(for: state)
        postAccessabilityNotification(for: state)
    }

    @objc
    public static func dismiss() {
        dismiss(completion: nil)
    }

    @objc
    public static func dismiss(completion: (() -> ())?) {
        shared.fadeOutLoader(completion: completion)
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: nil)
    }

    private static func performHapticFeedbackIfNeeded(for state: LoaderState) {
        guard #available(iOS 10.0, *) else { return }
        let generator = UINotificationFeedbackGenerator()
        switch state {
        case .loading:
            return
        case .failure:
            generator.notificationOccurred(.error)
        case .success:
            generator.notificationOccurred(.success)
        }
    }

    private static func postAccessabilityNotification(for state: LoaderState) {
        let accessibilityText: String
        switch state {
        case .loading:
            accessibilityText = "Loading"
        case .failure:
            accessibilityText = "Error"
        case .success:
            accessibilityText = "Success"
        }
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: nil)
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: accessibilityText)
    }

    // MARK: - Lifecycle

    private init() {
        super.init(nibName: nil, bundle: Bundle(for: LoaderHUD.self))
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        centerHUD(accountingFor: keyboardHeight()) // keyboard can be visible before we subscribed to notifications
        subscribeToKeyboardNotifications()
        subscribeToLayoutChangeNotifications()
        positionView()
        setupUI()
    }

    // MARK: - Keyboard handling

    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        centerHUD(accountingFor: keyboardHeight)
    }

    @objc
    private func keyboardWillHide() {
        verticalCenteringConstraint.constant = 0
    }

    // MARK: - Layout handling

    private func centerHUD(accountingFor keyboardHeight: CGFloat) {
        guard let screenHeight = UIApplication.shared.keyWindow?.bounds.height else { return }
        let screenCenterYPoint = screenHeight / 2
        let visibleScreenCenterYPoint = (screenHeight - keyboardHeight) / 2
        verticalCenteringConstraint.constant = screenCenterYPoint - visibleScreenCenterYPoint
    }

    private func keyboardHeight() -> CGFloat {
        guard let keyboardWindow = UIApplication.shared.windows.first(where: {
            return type(of: $0) != UIWindow.self
        }) else {
            return 0
        }
        for view in keyboardWindow.subviews {
            let viewName = String(describing: type(of: view))
            if viewName.hasPrefix("UI") {
                if viewName.hasSuffix("PeripheralHostView") || viewName.hasSuffix("Keyboard") {
                    return view.bounds.height
                } else if viewName.hasSuffix("InputSetContainerView") {
                    for subview in view.subviews {
                        let subviewName = String(describing: type(of: subview))
                        if subviewName.hasPrefix("UI") && subviewName.hasSuffix("InputSetHostView") {
                            let convertedRect = view.convert(subview.frame, to: self.view)
                            return convertedRect.height
                        }
                    }
                }
            }
        }
        return 0
    }

    private func visibleWindow() -> UIWindow? {
        return UIApplication.shared.windows.reversed().first { window in
            let onMainScreen = window.screen == UIScreen.main
            let isVisible = !window.isHidden && window.alpha > 0
            return onMainScreen && isVisible && window.isKeyWindow
        }
    }

    @objc
    private func positionView() {
        view.frame = UIApplication.shared.keyWindow?.bounds ?? .zero
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    // MARK: - Transitioning

    private func fadeInLoader() {
        view.alpha = 0
        visibleWindow()?.addSubview(view)
        UIView.animate(
            withDuration: LoaderPresentationFadeInDuration,
            animations: {
                self.view.alpha = 1
            }
        )
    }

    private func fadeOutLoader(completion: (() -> ())? = nil) {
        UIView.animate(
            withDuration: LoaderPresentationFadeInDuration,
            animations: {
                self.view.alpha = 0
            },
            completion: { _ in
                self.view.removeFromSuperview()
                completion?()
            }
        )
    }

    // MARK: - Notification Handling

    private func subscribeToKeyboardNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func subscribeToLayoutChangeNotifications() {
        let notifications: [NSNotification.Name] = [
            UIApplication.didChangeStatusBarOrientationNotification,
            UIApplication.didBecomeActiveNotification,
        ]
        notifications.forEach {
            NotificationCenter.default.addObserver(self, selector: #selector(positionView), name: $0, object: nil)
        }
    }

    // MARK: - Helpers

    private func setupUI() {
        view.backgroundColor = Color(.grayscale1, alpha: 0.5)
        containerView.backgroundColor = Color(.grayscale9)
        containerView.layer.cornerRadius = RadiusSize.default.value(size: self.view.frame.size)
        embed(
            view: loaderView,
            inContainerView: containerView,
            margins: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        )
    }
}
