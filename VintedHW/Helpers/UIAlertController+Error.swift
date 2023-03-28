import UIKit

extension UIAlertController {
    static func alert(_ error: Error) {
        UIApplication
            .shared
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .present(
                UIAlertController(
                    title: __("error"),
                    message: error.localizedDescription,
                    preferredStyle: .alert
                ),
                animated: true,
                completion: nil
            )
    }
}
