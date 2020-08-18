extension Resource {
    public enum Icon {
        case camera24
        case camera48
        case chevronDown24
        case chevronUp24
        case infoCircle16
        case infoCircle24
        case xCircleFilledBg24
        case showPassword
        case hidePassword
        case redirect24
        case lock24
    }
}

extension Resource.Icon {
    public var image: UIImage {
        let bundle = Bundle(for: Icon.self)
        let image: UIImage?
        
        switch self {
        case .camera24:
            image = UIImage(named: "camera-24", in: bundle, compatibleWith: nil)
        case .camera48:
            image = UIImage(named: "camera-48", in: bundle, compatibleWith: nil)
        case .chevronDown24:
            image = UIImage(named: "chevron-down-24", in: bundle, compatibleWith: nil)
        case .chevronUp24:
            image = UIImage(named: "chevron-up-24", in: bundle, compatibleWith: nil)
        case .infoCircle16:
            image = UIImage(named: "info-circle-16", in: bundle, compatibleWith: nil)
        case .infoCircle24:
            image = UIImage(named: "info-circle-24", in: bundle, compatibleWith: nil)
        case .xCircleFilledBg24:
            image = UIImage(named: "x-circle-filled-bg-24", in: bundle, compatibleWith: nil)
        case .showPassword:
            image = UIImage(named: "showPassword", in: bundle, compatibleWith: nil)
        case .hidePassword:
            image = UIImage(named: "hidePassword", in: bundle, compatibleWith: nil)
        case .redirect24:
            image = UIImage(named: "redirect-24", in: bundle, compatibleWith: nil)
        case .lock24:
            image = UIImage(named: "lock-24", in: bundle, compatibleWith: nil)
        }
        
        return image!
    }
}
