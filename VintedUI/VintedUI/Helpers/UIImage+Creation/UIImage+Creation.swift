extension UIImage {
    @objc
    public static func imageFromColor(fromColor color: UIColor?, with size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        if let cg = color?.cgColor {
            context?.setFillColor(cg)
        }
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    static func screenshot() -> UIImage? {
        var layer: CALayer?
        layer = UIApplication.shared.keyWindow?.layer
        let size = UIScreen.main.bounds.size
        UIGraphicsBeginImageContext(size)
        UIGraphicsGetCurrentContext()?.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let context = UIGraphicsGetCurrentContext() {
            layer?.render(in: context)
        }
        let screenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return screenImage
    }

    public func tintedImage(using tintColor: UIColor?) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        let rect = CGRect(origin: CGPoint.zero, size: size)
        context?.setBlendMode(.normal)
        draw(in: rect)

        context?.setBlendMode(.sourceIn)
        tintColor?.setFill()
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @objc
    public static func gradientImage(from beginColor: UIColor?, to endColor: UIColor?, imageSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        let gradientColors: CFArray? = [beginColor?.cgColor, endColor?.cgColor] as CFArray
        let gradientLocation: [CGFloat] = [0, 1]
        var gradient: CGGradient?
        if let colors = gradientColors {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: gradientLocation)
        }
        let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        context?.saveGState()
        bezierPath.addClip()
        let beginPoint = CGPoint(x: imageSize.width / 2, y: 0)
        let endPoint = CGPoint(x: imageSize.width / 2, y: imageSize.height)
        if let gradient = gradient {
            context?.drawLinearGradient(gradient, start: beginPoint, end: endPoint, options: [])
        }
        context?.setStrokeColor(Color(.grayscale1).cgColor)
        bezierPath.lineWidth = 0.0
        bezierPath.stroke()
        context?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func grayScale() -> UIImage? {
        var newImage: UIImage?
        let colorSapce = CGColorSpaceCreateDeviceGray()
        let cgImage = self.cgImage
        let width = cgImage?.width ?? 0
        let height = cgImage?.height ?? 0
        let scaledWidth = Int(CGFloat(width) * scale)
        let scaledHeight = Int(CGFloat(height) * scale)
        let context: CGContext? = CGContext(data: nil, width: scaledWidth, height: scaledHeight, bitsPerComponent: 8, bytesPerRow: scaledWidth, space: colorSapce, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
        context?.interpolationQuality = CGInterpolationQuality.high
        context?.setShouldAntialias(false)
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(scaledWidth), height: CGFloat(scaledHeight)))

        let bwImage = context?.makeImage()
        var resultImage: UIImage?
        if let bwImage = bwImage {
            resultImage = UIImage(cgImage: bwImage)
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        resultImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
