public enum VintedUIAsset {
    case heartActive
    case heartInactive
    case whiteCheckmark
    case close
    case redirect
    case copy
    case searchMembers
    case searchItems
    case emptyHanger
    case successCheck
    case statusActive
    case checkmarkShield
    case checkCircle
    case cancelCircle
    case envelope
    case home
    case edit
    case itemPlaceholderIcon
    case emptyItem
    case userDefaultAvatar
    case emptyAvatar
    case flag24
    case infoCircleFilled
    case plusSquare30
    case add16
    case carrier48
    case colorGold
    case colorSilver
    case colorVarious
    case bumpVinted
    case bumpVintedKids
    case bannerBackground
    case attention
    case plus16
    case horizontalDots
    case bank24
}

public extension VintedUIAsset {
    var image: UIImage {
        vintedUIAsset(named: self)
    }
}

public func vintedUIAsset(named name: VintedUIAsset) -> UIImage {
    switch name {
    case .heartActive:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "heartActive"))
    case .heartInactive:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "heartInactive"))
    case .whiteCheckmark:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "checkmark-16")).image(withColor: Color(.grayscale9))!
    case .close:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "close"))
    case .redirect:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "redirect-24"))
    case .copy:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "copy-24"))
    case .searchMembers:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "member-empty-state-96"))
    case .searchItems:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "search-empty-state-96"))
    case .emptyHanger:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "hanger-empty-state-96"))
    case .successCheck:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "successCheck"))
    case .statusActive:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "status-active-24"))
    case .checkmarkShield:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "checkmark-shield-16"))
    case .checkCircle:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "check-circle-24"))
    case .cancelCircle:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "cancel-circle-24"))
    case .envelope:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "envelope-24"))
    case .home:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "home-24"))
    case .edit:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "edit"))
    case .itemPlaceholderIcon:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "ItemPlaceholderIcon"))
    case .emptyItem:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "emptyItem"))
    case .userDefaultAvatar:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "userDefaultAvatar"))
    case .emptyAvatar:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "emptyAvatar"))
    case .flag24:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "flag-24"))
    case .infoCircleFilled:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "info-circle-filled-20"))
    case .plusSquare30:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "plus-square-30"))
    case .add16:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "add-16"))
    case .carrier48:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "carrier-48"))
    case .colorGold:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "color_gold"))
    case .colorSilver:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "color_silver"))
    case .colorVarious:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "color_various"))
    case .bumpVinted:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "bump_vinted"))
    case .plus16:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "plus-16"))
    case .bumpVintedKids:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "bump_vintedkids"))
    case .bannerBackground:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "banner-background"))
    case .attention:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "attention-16"))
    case .horizontalDots:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "horizontal-dots-24"))
    case .bank24:
        return UIImage.inCurrentBundle(#imageLiteral(resourceName: "bank-24"))
    }
}

func asset(named name: String) -> UIImage {
    return VintedUIAssetLoader.loadAsset(named: name)
}

final class VintedUIAssetLoader: NSObject {
    class func loadAsset(named name: String) -> UIImage {
        let bundle = Bundle(for: VintedUIAssetLoader.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)!
    }
}

private extension UIImage {
    static func inCurrentBundle(_ wrappedImage: CurrentBundleImage) -> UIImage {
        return wrappedImage.image
    }
}

extension Bundle {
    
    private class BundleClass {}
    
    static var current: Bundle {
        return Bundle(for: BundleClass.self)
    }
}

private struct CurrentBundleImage: _ExpressibleByImageLiteral {

    fileprivate let image: UIImage

    init(imageLiteralResourceName name: String) {
        image = UIImage(named: name, in: .current, compatibleWith: nil)!
    }
}
