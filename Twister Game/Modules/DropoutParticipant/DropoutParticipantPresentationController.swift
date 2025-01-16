import UIKit

final class DropoutParticipantPresentationController: CommonPresentationController {
  private var dropoutVC: DropoutParticipantViewController? {
    presentedViewController as? DropoutParticipantViewController
  }
  
  override var indent: CGFloat {
    (containerView!.frame.height - self.height) / 2
  }
  
  override var customHeight: CGFloat {
    let contentVStackTopIndent = dropoutVC?.contentVStackTop.constant ?? 0
    let labelsVStackHeight = (dropoutVC?.mainTitle.requiredHeight ?? 0) + (dropoutVC?.additionalTitle.requiredHeight ?? 0) + (dropoutVC?.titlesVStack.spacing ?? 0)
    let participantsVStackHeight = dropoutVC?.participantsVStack.frame.height ?? 0
    let contentVStackSpacing = dropoutVC?.contentVStack.spacing ?? 0
    
    let buttonsVStackTopIndent = dropoutVC?.buttonsVStackTop.constant ?? 0
    let buttonsVStackHeight = dropoutVC?.buttonsVStack.frame.height ?? 0
    let buttonsVStackBottomIndent = dropoutVC?.buttonsVStackBottom.constant ?? 0
    
    return contentVStackTopIndent + labelsVStackHeight + participantsVStackHeight + contentVStackSpacing + buttonsVStackTopIndent + buttonsVStackHeight + buttonsVStackBottomIndent
  }
  override var customWidth: CGFloat {
    containerView!.frame.width - (Constants.hIndent * 2)
  }
  //MARK: - Override to set cornerRadius
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    presentedView?.roundCorners(.allCorners, radius: Constants.radius)
    presentedView?.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    dropoutVC?.reCreateGradientLayer()
  }
}
//MARK: - Constants
fileprivate struct Constants {
  static var hIndent: CGFloat { 16.0 }
  static var radius: CGFloat { 32.0 }
}
