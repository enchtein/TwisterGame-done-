import UIKit

enum TwisterSectionColorType: Int, CaseIterable {
  case green
  case red
  case yellow
  case blue
  
  var color: UIColor {
    switch self {
    case .green: AppColor.colorFour
    case .red: AppColor.colorOne
    case .yellow: AppColor.colorThree
    case .blue: AppColor.colorTwo
    }
  }
  var title: String {
    switch self {
    case .green: GameTitles.green.localized
    case .red: GameTitles.red.localized
    case .yellow: GameTitles.yellow.localized
    case .blue: GameTitles.blue.localized
    }
  }
}
