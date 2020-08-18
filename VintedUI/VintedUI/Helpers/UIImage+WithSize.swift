public extension UIImage {
    func image(scaledToSize newSize: IconSize) -> UIImage? {
        guard !newSize.size.equalTo(size) else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(newSize.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.size.width, height: newSize.size.height)))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            return newImage
        } else {
            return nil
        }
    }
    
    func aspectFit(target: CGSize) -> UIImage? {
        guard size.width != 0 && size.height != 0 else { return nil }
        
        let scale = min(target.width / size.width, target.height / size.height)
        var targetRect = CGRect(origin: .zero, size: size)
        targetRect.size.width *= scale
        targetRect.size.height *= scale
        
        UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: targetRect)
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            return newImage
        }
        return nil
    }
}
