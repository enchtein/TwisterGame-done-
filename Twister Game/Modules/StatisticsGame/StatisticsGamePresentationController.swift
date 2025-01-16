import UIKit

final class StatisticsGamePresentationController: CommonPresentationController {
  private var staticticsVC: StatisticsGameViewController? {
    presentedViewController as? StatisticsGameViewController
  }
  
  override var indent: CGFloat {
    (containerView!.frame.height - self.height) / 2
  }
  
  override var customHeight: CGFloat {
    let contentVStackTopIndent = staticticsVC?.titlesVStackTop.constant ?? 0
    let labelsVStackHeight = (staticticsVC?.mainTitle.requiredHeight ?? 0) + (staticticsVC?.additionalTitle.requiredHeight ?? 0) + (staticticsVC?.titlesVStack.spacing ?? 0)
    
    let participantsInfoVStackTop = staticticsVC?.participantsInfoVStackTop.constant ?? 0
    
    let participantsInfoVStackSpacing = staticticsVC?.participantsInfoVStack.spacing ?? 0
    let participantsInfoVStackElemsCount = staticticsVC?.participantsInfoVStack.arrangedSubviews.count ?? 0
    let participantsInfoVStackSumSpacing = participantsInfoVStackElemsCount > 1 ? (CGFloat(participantsInfoVStackElemsCount - 1) * participantsInfoVStackSpacing) : 0
    
    let titlesHStackHeight = staticticsVC?.titlesHStack.frame.height ?? 0
    let dividerViewHeight = staticticsVC?.dividerView.frame.height ?? 0
    
    let statisticsVStackSpacing = staticticsVC?.statisticsVStack.spacing ?? 0
    let statisticsVStackElemsCount = staticticsVC?.statisticsVStack.arrangedSubviews.count ?? 0
    let statisticsVStackSumSpacing = statisticsVStackElemsCount > 1 ? (CGFloat(statisticsVStackElemsCount - 1) * statisticsVStackSpacing) : 0
    let statisticsVStackElemHeight = staticticsVC?.statisticsVStackMinHStackHeight ?? 0
    let statisticsVStackSumHeight = CGFloat(statisticsVStackElemsCount) * statisticsVStackElemHeight
    
    let buttonsVStackTopIndent = staticticsVC?.buttonsHStackTop.constant ?? 0
    let buttonsHStackHeight = staticticsVC?.buttonsHStack.frame.height ?? 0
    let buttonsVStackBottomIndent = staticticsVC?.buttonsHStackBottom.constant ?? 0
    
    return contentVStackTopIndent + labelsVStackHeight + participantsInfoVStackTop + participantsInfoVStackSumSpacing + titlesHStackHeight + dividerViewHeight + statisticsVStackSumSpacing + statisticsVStackSumHeight + buttonsVStackTopIndent + buttonsHStackHeight + buttonsVStackBottomIndent
  }
  override var customWidth: CGFloat {
    containerView!.frame.width - (Constants.hIndent * 2)
  }
  //MARK: - Override to set cornerRadius
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    presentedView?.roundCorners(.allCorners, radius: Constants.radius)
    presentedView?.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    staticticsVC?.reCreateGradientLayer()
  }
}
//MARK: - Constants
fileprivate struct Constants {
  static var hIndent: CGFloat { 16.0 }
  static var radius: CGFloat { 32.0 }
}
