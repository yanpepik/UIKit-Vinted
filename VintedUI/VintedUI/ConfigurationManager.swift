public protocol Configuration {

    var linkExtraction: LinkExtractionConfiguration { get }
    var urlHandling: URLHandlingConfiguration { get }
}

public protocol LinkExtractionConfiguration {

    var mentionAttributeName: String { get }
    var hashtagAttributeName: String { get }
    func processingMentions(in attributedString: NSAttributedString) -> NSAttributedString
    func processingHashtags(in attributedString: NSAttributedString) -> NSAttributedString
}

public protocol URLHandlingConfiguration {

    func itemSearch(from query: String) -> URL?
    func userLogin(from query: String) -> URL?
    func handle(_ url: URL)
}

public final class ConfigurationManager {

    static let shared = ConfigurationManager()

    private(set) var configuration: Configuration = DefaultConfiguration()

    public static func configure(with configuration: Configuration) {
        shared.configure(with: configuration)
    }

    private func configure(with configuration: Configuration) {
        self.configuration = configuration
    }
}

private struct DefaultConfiguration: Configuration {

    var linkExtraction: LinkExtractionConfiguration { DefaultLinkExtractionConfiguration() }
    var urlHandling: URLHandlingConfiguration { DefaultURLHandlingConfiguration() }
}

private struct DefaultLinkExtractionConfiguration: LinkExtractionConfiguration {

    var mentionAttributeName: String {
        assertionFailure("Framework `VintedUI` is not configured!")
        return "VintedMentionAttributeName"
    }

    var hashtagAttributeName: String {
        assertionFailure("Framework `VintedUI` is not configured!")
        return "VintedHashtagAttributeName"
    }

    func processingMentions(in attributedString: NSAttributedString) -> NSAttributedString {
        assertionFailure("Framework `VintedUI` is not configured!")
        return attributedString
    }

    func processingHashtags(in attributedString: NSAttributedString) -> NSAttributedString {
        assertionFailure("Framework `VintedUI` is not configured!")
        return attributedString
    }
}

private struct DefaultURLHandlingConfiguration: URLHandlingConfiguration {

    func itemSearch(from query: String) -> URL? {
        assertionFailure("Framework `VintedUI` is not configured!")
        return nil
    }

    func userLogin(from query: String) -> URL? {
        assertionFailure("Framework `VintedUI` is not configured!")
        return nil
    }

    func handle(_ url: URL) {
        assertionFailure("Framework `VintedUI` is not configured!")
    }
}
