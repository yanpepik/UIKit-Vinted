public struct Portal {
    public static let current = Portal(code: "en", domain: "http://mobile-homework-api.vinted.net", locale: "en")
    public let apiDomain: String
    
    let code: String
    let locale: String
    
    init(code: String, domain: String, locale: String) {
        self.code = code
        self.apiDomain = domain
        self.locale = locale
    }
}
