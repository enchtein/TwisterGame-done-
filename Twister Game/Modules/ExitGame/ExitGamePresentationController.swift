import UIKit

final class ExitGamePresentationController: CommonPresentationController {
  private var exitVC: ExitGameViewController? {
    presentedViewController as? ExitGameViewController
  }
  
  override var indent: CGFloat {
    (containerView!.frame.height - self.height) / 2
  }
  
  override var customHeight: CGFloat {
    let contentVStackTopIndent = exitVC?.titlesVStackTop.constant ?? 0
    let labelsVStackHeight = (exitVC?.mainTitle.requiredHeight ?? 0) + (exitVC?.additionalTitle.requiredHeight ?? 0) + (exitVC?.titlesVStack.spacing ?? 0)
    
    let buttonsVStackTopIndent = exitVC?.buttonsVStackTop.constant ?? 0
    let buttonsVStackHeight = exitVC?.buttonsVStack.frame.height ?? 0
    let buttonsVStackBottomIndent = exitVC?.buttonsVStackBottom.constant ?? 0
    
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
    exitVC?.reCreateGradientLayer()
  }
}
//MARK: - Constants
fileprivate struct Constants {
  static var hIndent: CGFloat { 16.0 }
  static var radius: CGFloat { 32.0 }
}
