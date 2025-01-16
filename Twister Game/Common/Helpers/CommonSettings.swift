import Foundation

protocol CommonSettings {
  static var animationDuration: TimeInterval { get }
  static var minScaleFactor: CGFloat { get }
  
  static var baseSideIndent: CGFloat { get }
  
  static var targetOpacity: TargetActionsOpacity { get }
  
  static func sizeProportion(for maxSize: CGFloat, minSize: CGFloat) -> CGFloat
  
  static var containerTopRadius: CGFloat { get }
}
extension CommonSettings {
  static var animationDuration: TimeInterval { 0.5 }
  static var minScaleFactor: CGFloat { 0.5 }
  
  static var baseSideIndent: CGFloat { sizeProportion(for: 24.0, minSize: 16.0) }
  
  static var targetOpacity: TargetActionsOpacity { TargetActionsOpacity() }
  
  static func sizeProportion(for maxSize: CGFloat, minSize: CGFloat = 0.0) -> CGFloat {
    let sizeProportion = maxSize.sizeProportion
    
    let res: CGFloat
    if minSize > .zero {
      let sizedValue = sizeProportion > maxSize ? maxSize : sizeProportion
      res = sizedValue < minSize ? minSize : sizedValue
    } else {
      res = sizeProportion > maxSize ? maxSize : sizeProportion
    }
    
    return res
  }
  
  static var containerTopRadius: CGFloat {
    sizeProportion(for: 48.0)
  }
}

//MARK: - TargetActionsOpacity
struct TargetActionsOpacity {
  let base: Float = 1.0
  let highlighted: Float = 0.7
  let disabled: Float = 0.3
}
