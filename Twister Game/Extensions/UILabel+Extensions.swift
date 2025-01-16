import UIKit

extension UILabel {
  var requiredHeight: CGFloat {
    requiredHeight(accordingWidth: frame.width)
  }
  
  func requiredHeight(accordingWidth: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: accordingWidth, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
  }
}
