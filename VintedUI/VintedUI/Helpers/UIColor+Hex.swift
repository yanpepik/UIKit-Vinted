public extension UIColor {
    @objc
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1)
    }
    
    @objc
    convenience init?(hexString: String, alpha: CGFloat) {
        var hexStringUpper = hexString.uppercased()
        
        if hexStringUpper.hasPrefix("0X") {
            let index = hexStringUpper.index(hexStringUpper.startIndex, offsetBy: 2)
            hexStringUpper = String(hexStringUpper[index...])
        } else if hexStringUpper.hasPrefix("#") {
            let index = hexStringUpper.index(hexStringUpper.startIndex, offsetBy: 1)
            hexStringUpper = String(hexStringUpper[index...])
        }
        
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexStringUpper)
        
        guard scanner.scanHexInt64(&rgbValue) else {
            self.init()
            return nil
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
