import UIKit

@objc protocol ParticipantFieldDelegate: AnyObject {
  @objc optional func fieldValueDidChange(for participantField: ParticipantField)
  @objc optional func selectableButtonAction(for participantField: ParticipantField)
}
final class ParticipantField: UIView {
  let isSelectable: Bool
  private(set) var isFocusedField: Bool = false
  
  let placeholder: String
  
  private lazy var hStack = createHStack()
  private(set) lazy var textField = createTextField()
  
  private lazy var clearButton = createClearButton()
  private lazy var selectedButton = createSelectedButton()
  
  private lazy var selectableButton = createSelectableButton()
  
  private weak var delegate: ParticipantFieldDelegate?
  
  var isEnabled: Bool = true {
    didSet {
      guard oldValue != isEnabled else { return }
      enabledStateDidChange()
    }
  }
  
  init(isSelectable: Bool, placeholder: String, delegate: ParticipantFieldDelegate) {
    self.isSelectable = isSelectable
    self.placeholder = placeholder
    self.delegate = delegate
    
    super.init(frame: .zero)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(hStack)
    hStack.fillToSuperview(horizontalIndents: 16.0)
    hStack.addArrangedSubview(textField)
    
    if isSelectable {
      hStack.addArrangedSubview(selectedButton)
    } else {
      hStack.addArrangedSubview(clearButton)
    }
    
    backgroundColor = Constants.bgColor
    layer.borderColor = Constants.borderNonSelectedColor.cgColor
    layer.borderWidth = Constants.borderWidth
    cornerRadius = Constants.radius
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    
    updateUIAccordingFocusedState()
    
    if isSelectable {
      addSubview(selectableButton)
      selectableButton.fillToSuperview()
    }
  }
}
//MARK: - UI elements creating
private extension ParticipantField {
  func createHStack() -> UIStackView {
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = Constants.hStackSpacing
    return hStack
  }
  
  func createTextField() -> UITextField {
    let textField = UITextField()
    textField.borderStyle = .none
    textField.font = Constants.font
    textField.textColor = Constants.textColor
    textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: Constants.placeholderColor, .font: Constants.font])
    textField.tintColor = AppColor.layerThree
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    textField.addTarget(self, action: #selector(fieldValueDidChange), for: .editingChanged)
    
    return textField
  }
  func createClearButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.ParticipantField.clear, for: .normal)
    button.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
    
    return button
  }
  func createSelectedButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.ParticipantField.selected, for: .normal)
    
    return button
  }
  
  func createSelectableButton() -> UIButton {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(setOpaqueButton), for: .touchDown)
    button.addTarget(self, action: #selector(setNonOpaquesButton), for: .touchDragExit)
    button.addTarget(self, action: #selector(setOpaqueButton), for: .touchDragEnter)
    button.addTarget(self, action: #selector(setNonOpaquesButton), for: .touchUpInside)
    button.addTarget(self, action: #selector(selectableButtonAction), for: .touchUpInside)
    
    return button
  }
}

//MARK: - SelectableButton Actions
extension ParticipantField {
  @objc private func selectableButtonAction() {
    delegate?.selectableButtonAction?(for: self)
  }
  
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
    self.isUserInteractionEnabled = isEnabled
    UIView.animate(withDuration: Constants.animationDuration) {
      self.layer.opacity = self.isEnabled ? Constants.actionsOpacity.base : Constants.actionsOpacity.disabled
    }
  }
}
//MARK: - UI Common elements creating
private extension ParticipantField {
  func createButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: Constants.iconSize.width).isActive = true
    button.heightAnchor.constraint(equalToConstant: Constants.iconSize.height).isActive = true
    
    return button
  }
}
private extension ParticipantField {
  @objc func clearButtonAction() {
    let isEmptyText = (textField.text ?? "").isEmpty
    
    if !isEmptyText {
      textField.text = nil
      delegate?.fieldValueDidChange?(for: self)
    }
    
    if isEmptyText, isFocusedField {
      textField.resignFirstResponder()
    } else {
      textField.becomeFirstResponder()
    }
    
    
  }
  @objc func fieldValueDidChange() {
    delegate?.fieldValueDidChange?(for: self)
  }
}
//MARK: - API
extension ParticipantField {
  func update(to isFocusedField: Bool) {
    self.isFocusedField = isFocusedField
    
    updateUIAccordingFocusedState()
  }
}
//MARK: - Helpers
private extension ParticipantField {
  func updateUIAccordingFocusedState() {
    if isSelectable {
      updateSelectableUIAccordingFocusedState()
    } else {
      updateEditableUIAccordingFocusedState()
    }
  }
  func updateSelectableUIAccordingFocusedState() {
    if isFocusedField {
      selectedButton.showAnimated(in: hStack)
    } else {
      selectedButton.hideAnimated(in: hStack)
    }
    
    let borderColor = isFocusedField ? Constants.borderColor : Constants.borderNonSelectedColor
    UIView.animate(withDuration: animationDuration) {
      self.layer.borderColor = borderColor.cgColor
    }
  }
  func updateEditableUIAccordingFocusedState() {
    if isFocusedField {
      clearButton.showAnimated(in: hStack)
    } else {
      if textField.text?.isEmpty ?? true {
        clearButton.hideAnimated(in: hStack)
      }
    }
    
    let borderColor = isFocusedField ? Constants.borderColor : Constants.borderNonSelectedColor
    UIView.animate(withDuration: animationDuration) {
      self.layer.borderColor = borderColor.cgColor
    }
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var height: CGFloat {
    sizeProportion(for: 56.0, minSize: 44.0)
  }
  static var radius: CGFloat {
    sizeProportion(for: 16.0, minSize: 12.0)
  }
  static var hStackSpacing: CGFloat {
    sizeProportion(for: 8.0)
  }
  
  static let iconSize: CGSize = .init(width: 24.0, height: 24.0)
  
  static let bgColor = AppColor.layerSeven
  
  static let borderWidth: CGFloat = 2.0
  static let borderColor = AppColor.layerOne
  static let borderNonSelectedColor = AppColor.layerSeven
  
  static var font: UIFont {
    let fontSize = sizeProportion(for: 18.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  
  static let placeholderColor = AppColor.layerFour
  static let textColor = AppColor.layerOne
  
  static let actionsOpacity = TargetActionsOpacity()
}
