import UIKit

enum FontType {
  case madaRegular
  case madaSemiBold
  case madaBold
  
  case maderaExtraBold
  
  fileprivate var type: String {
    switch self {
    case .madaRegular: "Mada-Regular" //400
    case .madaSemiBold: "Mada-SemiBold" //600
    case .madaBold: "Mada-Bold" //700
    case .maderaExtraBold: "MaderaW01-ExtraBold" //800
    }
  }
}

struct AppFont {
  static func font(type: FontType, size: CGFloat) -> UIFont {
    UIFont(name: type.type, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
  }
  static func font(type: FontType, size: Int) -> UIFont {
    font(type: type, size: CGFloat(size))
  }
}
