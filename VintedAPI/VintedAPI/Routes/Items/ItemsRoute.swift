import Foundation

public final class ItemsRoute: Route<FeedEvents> {
    public init(page: Int = 0) {
        super.init(
            baseURL: Portal.current.apiDomain,
            endpoint: "/items",
            method: .get,
            params: ["page": page]
        )
    }
}
