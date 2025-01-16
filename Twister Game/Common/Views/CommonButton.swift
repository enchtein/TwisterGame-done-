import UIKit

final class CommonButton: UIButton {
  private(set) var enabledBgColor: UIColor = AppColor.accentOne
  private(set) var enabledTitleColor: UIColor = AppColor.layerOne
  
  private var customRadius: CGFloat?
  private var customShadowColor: UIColor?
  
  private var innerShadowColor: UIColor?
  
  private lazy var buttonHeight: NSLayoutConstraint = {
    let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Constants.height)
    heightConstraint.priority = UILayoutPriority(999)
    return heightConstraint
  }()
  
  override var isEnabled: Bool {
    didSet {
      guard oldValue != isEnabled else { return }
      enabledStateDidChange()
    }
  }
  
  init() {
    super.init(frame: .zero)
    
    setupUI()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupUI()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let radius = customRadius ?? Constants.cornerRadius
    if let innerShadowColor {
      setupInnerShadow(with: innerShadowColor)
    } else {
      let shadowColor = customShadowColor ?? AppColor.shadowOne
      setShadow(with: radius, and: shadowColor)
    }
  }
  
  private final func setupUI() {
    buttonHeight.isActive = true
    
    backgroundColor = enabledBgColor
    
    setTitle("temp title", for: .normal)
    setTitleColor(enabledTitleColor, for: .normal)
    titleLabel?.font = Constants.font
    
    addTarget(self, action: #selector(setOpaqueButton), for: .touchDown)
    addTarget(self, action: #selector(setNonOpaquesButton), for: .touchDragExit)
    addTarget(self, action: #selector(setOpaqueButton), for: .touchDragEnter)
    addTarget(self, action: #selector(setNonOpaquesButton), for: .touchUpInside)
  }
}

//MARK: - CommonButton Actions
extension CommonButton {
  @objc private func setOpaqueButton() {
    updateButtonOpacity(true)
  }
  @objc private func setNonOpaquesButton() {
    updateButtonOpacity(false)
  }
  private func updateButtonOpacity(_ isOpaque: Bool) {
    guard isEnabled else { return }
    layer.opacity = isOpaque ? Constants.actionsOpacity.highlighted : Constants.actionsOpacity.base
  }
  
  private func enabledStateDidChange() {
    UIView.animate(withDuration: Constants.animationDuration) {
      self.backgroundColor = self.isEnabled ? self.enabledBgColor: self.enabledBgColor.withAlphaComponent(0.3)
    }
  }
}
//MARK: - API
extension CommonButton {
  func setupTitle(with text: String, animated: Bool = false) {
    if animated {
      UIView.transition(with: self, duration: animationDuration, options: .transitionCrossDissolve) {
        self.setTitle(text, for: .normal)
      }
    } else {
      setTitle(text, for: .normal)
    }
  }
  func setupIcon(with image: UIImage) {
    setImage(image, for: .normal)
  }
  func setupEnabledBgColor(to color: UIColor) {
    enabledBgColor = color
    backgroundColor = color
  }
  func setupEnabledTitleColor(to color: UIColor) {
    enabledTitleColor = color
    setTitleColor(color, for: .normal)
  }
  func setupHeight(to value: CGFloat) {
    buttonHeight.constant = value
    setNeedsLayout()
    layoutIfNeeded()
  }
  func setupCornerRadius(to value: CGFloat) {
    customRadius = value
    setNeedsLayout()
    layoutIfNeeded()
  }
  func setupShadowColor(to color: UIColor) {
    customShadowColor = color
    setNeedsLayout()
    layoutIfNeeded()
  }
  func setupFont(to font: UIFont) {
    titleLabel?.font = font
  }
  func setupTitle(titleEdgeInsets: UIEdgeInsets) {
    self.titleEdgeInsets = titleEdgeInsets
  }
  
  func setupInnerShadow(with color: UIColor) {
    let radius = customRadius ?? Constants.cornerRadius
    innerShadowColor = color
    setInnerShadow(with: radius, and: color)
  }
  func setupBorderColor(to color: UIColor) {
    layer.borderColor = color.cgColor
    layer.borderWidth = 1.0
  }
}
//MARK: - CommonButton Constants
fileprivate struct Constants: CommonSettings {
  static var height: CGFloat {
    let maxHeight = 70.0
    let sizeProportion = maxHeight.sizeProportion
    
    return sizeProportion > maxHeight ? maxHeight : sizeProportion
  }
  
  static var cornerRadius: CGFloat {
    let max = 24.0
    let sizeProportion = max.sizeProportion
    
    return sizeProportion > max ? max : sizeProportion
  }
  
  static let actionsOpacity = TargetActionsOpacity()
  
  static var font: UIFont {
    let maxFontSize = 20.0
    let sizeProportion = maxFontSize.sizeProportion
    let fontSize = sizeProportion > maxFontSize ? maxFontSize : sizeProportion
    
    return AppFont.font(type: .madaBold, size: fontSize)
  }
}
