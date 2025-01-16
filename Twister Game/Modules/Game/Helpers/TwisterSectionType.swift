import UIKit

enum TwisterSectionType: Int, CaseIterable {
  case leftHand = 0
  case leftLeg
  case rightHand
  case rightLeg
  
  var title: String {
    switch self {
    case .leftHand: GameTitles.left.localized
    case .leftLeg: GameTitles.left.localized
    case .rightHand: GameTitles.right.localized
    case .rightLeg: GameTitles.right.localized
    }
  }
  var fullTitle: String {
    switch self {
    case .leftHand: GameTitles.leftHand.localized
    case .leftLeg: GameTitles.leftLeg.localized
    case .rightHand: GameTitles.rightHand.localized
    case .rightLeg: GameTitles.rightLeg.localized
    }
  }
  
  var image: UIImage {
    switch self {
    case .leftHand: AppImage.Game.hand
    case .leftLeg: AppImage.Game.leg
    case .rightHand: AppImage.Game.hand
    case .rightLeg: AppImage.Game.leg
    }
  }
}
