private let TitleToSubtitleMargin = 2.units
private let DefaultTitleIconSize: CGFloat = 13

final class VintedCellTitleAndSubtitleView: UIView, NibLoadable {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var subtitleSpacing: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.preferredMaxLayoutWidth = frame.width - subtitleLabel.frame.width - subtitleSpacing.constant
    }
    
    func setupLabels(title: String?, subtitle: String?, titleIcon: UIImage?, inversed: Bool) {
        let attributedTitle = attributedText(string: title, type: .title, inversed: inversed)
        titleLabel.accessibilityIdentifier = title
                
        if let attributedTitle = attributedTitle, let titleIcon = titleIcon {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            let textAttachment = NSTextAttachment()
            textAttachment.image = titleIcon
            textAttachment.bounds = CGRect(x: SpacerSize.regular.floatValue, y: -1, width: DefaultTitleIconSize, height: DefaultTitleIconSize)
            let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
            mutableAttributedTitle.append(attributedStringWithImage)
            titleLabel.attributedText = mutableAttributedTitle
        } else {
            titleLabel.attributedText = attributedTitle
        }
 
        if let attributedSubtitle = attributedText(string: subtitle, type: .subtitle, inversed: inversed) {
            subtitleLabel.attributedText = attributedSubtitle
            subtitleSpacing.constant = TitleToSubtitleMargin
        } else {
            subtitleLabel.attributedText = nil
            subtitleSpacing.constant = 0
        }
    }
}
