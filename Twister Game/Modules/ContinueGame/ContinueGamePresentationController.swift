import UIKit

final class ContinueGamePresentationController: CommonPresentationController {
  private var continueVC: ContinueGameViewController? {
    presentedViewController as? ContinueGameViewController
  }
  
  override var indent: CGFloat {
    (containerView!.frame.height - self.height) / 2
  }
  
  override var customHeight: CGFloat {
    let contentVStackTopIndent = continueVC?.titlesVStackTop.constant ?? 0
    let labelsVStackHeight = (continueVC?.mainTitle.requiredHeight ?? 0) + (continueVC?.additionalTitle.requiredHeight ?? 0) + (continueVC?.titlesVStack.spacing ?? 0)
    
    let buttonsVStackTopIndent = continueVC?.buttonsVStackTop.constant ?? 0
    let buttonsVStackHeight = continueVC?.buttonsVStack.frame.height ?? 0
    let buttonsVStackBottomIndent = continueVC?.buttonsVStackBottom.constant ?? 0
    
    return contentVStackTopIndent + labelsVStackHeight + buttonsVStackTopIndent + buttonsVStackHeight + buttonsVStackBottomIndent
  }
  override var customWidth: CGFloat {
    containerView!.frame.width - (Constants.hIndent * 2)
  }
  //MARK: - Override to set cornerRadius
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    presentedView?.roundCorners(.allCorners, radius: Constants.radius)
    presentedView?.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    continueVC?.reCreateGradientLayer()
  }
}
//MARK: - Constants
fileprivate struct Constants {
  static var hIndent: CGFloat { 16.0 }
  static var radius: CGFloat { 32.0 }
}
