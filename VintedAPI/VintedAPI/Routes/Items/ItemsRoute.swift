import Foundation

public final class ItemsRoute: Route<FeedEvents> {
    public struct Params: Encodable {
        let page: Int
        
        public init(page: Int) {
            self.page = page
        }
    }
    
    public init(params: Params) {
        super.init(
            baseURL: Portal.current.apiDomain,
            endpoint: "/items",
            method: .get,
            params: params
        )
    }
}
