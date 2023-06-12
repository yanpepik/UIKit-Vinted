import Foundation

public protocol KeyWindowProviding {
    var window: UIWindow? { get }
    var safeAreaInsets: UIEdgeInsets { get }
}

public extension KeyWindowProviding {
    var safeAreaInsets: UIEdgeInsets {
        window?.safeAreaInsets ?? .zero
    }
}
