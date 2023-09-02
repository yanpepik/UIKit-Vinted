import Foundation

public final class ItemsRoute: Route<FeedEvents> {
    public struct Params: Encodable {
        let page: Int
        let search_text: String?
        
        public init(page: Int, search_text: String?) {
            self.page = page
            self.search_text = search_text
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
