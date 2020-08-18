public protocol NotificationBannerPresentable {
    var shouldShowNotificationBanner: Bool { get }
    var notificationBannerPinView: UIView? { get }
}

public extension NotificationBannerPresentable {
    var shouldShowNotificationBanner: Bool { true }
    var notificationBannerPinView: UIView? { nil }
}
