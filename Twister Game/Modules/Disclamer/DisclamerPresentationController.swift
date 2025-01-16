import UIKit

final class DisclamerPresentationController: CommonPresentationController {
  private var disclamerVC: DisclamerViewController? {
    presentedViewController as? DisclamerViewController
  }
  
  override var indent: CGFloat {
    (containerView!.frame.height - self.height) / 2
  }
  
  override var customHeight: CGFloat {
    let titlesVStackHIndent = (disclamerVC?.titlesVStackLeading.constant ?? 0) + (disclamerVC?.titlesVStackTrailing.constant ?? 0)
    let titlesVStackWidth = customWidth - titlesVStackHIndent
    
    let mainTitleHeight = disclamerVC?.mainTitle.requiredHeight(accordingWidth: titlesVStackWidth) ?? 0
    let additionalTitleHeight = disclamerVC?.additionalTitle.requiredHeight(accordingWidth: titlesVStackWidth) ?? 0
    
    let contentVStackTopIndent = disclamerVC?.titlesVStackTop.constant ?? 0
    let labelsVStackHeight = mainTitleHeight + additionalTitleHeight + (disclamerVC?.titlesVStack.spacing ?? 0)
    
    let buttonTopIndent = disclamerVC?.okButtonTop.constant ?? 0
    let buttonHeight = disclamerVC?.okButton.frame.height ?? 0
    let buttonBottomIndent = disclamerVC?.okButtonBottom.constant ?? 0
    
    return contentVStackTopIndent + labelsVStackHeight + buttonTopIndent + buttonHeight + buttonBottomIndent
  }
  override var customWidth: CGFloat {
    containerView!.frame.width - (Constants.hIndent * 2)
  }
  //MARK: - Override to set cornerRadius
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    presentedView?.roundCorners(.allCorners, radius: Constants.radius)
    presentedView?.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    disclamerVC?.reCreateGradientLayer()
  }
}
//MARK: - Constants
fileprivate struct Constants {
  static var hIndent: CGFloat { 16.0 }
  static var radius: CGFloat { 32.0 }
}
