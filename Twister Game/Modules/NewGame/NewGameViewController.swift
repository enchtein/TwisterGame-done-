import UIKit

final class NewGameViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var navPanelContainer: UIView!
  @IBOutlet weak var navPanelContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
  @IBOutlet weak var scrollContainer: UIView!
  @IBOutlet weak var scrollContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var vStackContainer: UIView!
  @IBOutlet weak var vStack: UIStackView!
  
  @IBOutlet weak var panelButtonContainer: UIView!
  @IBOutlet weak var panelButtonVStack: UIStackView!
  @IBOutlet weak var panelButtonVStackTop: NSLayoutConstraint!
  @IBOutlet weak var panelButtonVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  @IBOutlet weak var createButton: CommonButton!
  
  @IBOutlet weak var randomiseVStack: UIStackView!
  @IBOutlet weak var randomiseVStackTop: NSLayoutConstraint!
  @IBOutlet weak var randomiseTitle: UILabel!
  @IBOutlet weak var randomiseButton: CommonButton!
  
  
  private var defaulScrollViewBottomIndent: CGFloat {
    screenHeight - safeArea.top - navPanelContainer.frame.height - expectedVStackHeight - panelButtonContainer.frame.height
  }
  private var allParticipantFieldContainers: [UIView] {
    vStack.arrangedSubviews.filter { $0.subviews.contains { $0 is ParticipantField } }
  }
  private var minParticipantFieldHeight: CGFloat? {
    allParticipantFieldContainers.min { $0.frame.height < $1.frame.height }?.frame.height
  }
  private var selectTypeGameHeight: CGFloat {
    viewModel.readyToRandomize ? .zero : (vStack.arrangedSubviews.first { $0 is UIControl }?.frame.height ?? .zero)
  }
  private var expectedVStackHeight: CGFloat {
    let spacersHeight = CGFloat(vStack.arrangedSubviews.count - 1) * 8.0
    let participantFieldsHeight = (minParticipantFieldHeight ?? .zero) * CGFloat(viewModel.countOfParticipants)
    
    let vIndent = 8.0 + 8.0
    
    return spacersHeight + selectTypeGameHeight + participantFieldsHeight + vIndent
  }
  private var allParticipantFields: [ParticipantField] {
    vStack.arrangedSubviews.map {$0.subviews}
      .reduce([], +)
      .filter {$0 is ParticipantField}
      .compactMap {$0 as? ParticipantField}
  }
  
  private lazy var navPanel = CommonNavPanel.init(type: .newGameCreation, delegate: self)
  private lazy var selectTypeButton = createSelectTypeGameButton()
  private lazy var selectTypeButtonTitle = createSelectTypeGameButtonTitle()
  
  var countOfParticipants: Int = 2
  var model: NewGameModel?
  private lazy var viewModel = NewGameViewModel.init(countOfParticipants: countOfParticipants, model: model, delegate: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel.viewDidLoad()
    hideKeyboardWhenTappedAround()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    vStackContainer.setInnerShadow(with: Constants.containerRadius, and: AppColor.innerShadow, shadowRadius: 2.0)
    selectTypeButton.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow, shadowRadius: 4.0)
  }
  override func kbFrameChange(to kbRect: CGRect) {
    if kbRect == .zero {
      
      scrollViewBottom.constant = defaulScrollViewBottomIndent
      scrollView.setContentOffset(.zero, animated: true)
      view.layoutIfNeeded()
    } else {
      if let tf = view.findFirstResponder() {
        let visibleArea = screenHeight - kbRect.height
        
        guard let globalFrame = tf.globalFrame else { return }
        let distance = visibleArea - globalFrame.maxY
        guard distance < .zero else { return }
        
        scrollViewBottom.constant = defaulScrollViewBottomIndent + abs(distance)
        scrollView.setContentOffset(CGPoint(x: 0, y: abs(distance)), animated: true)
        view.layoutIfNeeded()
      } else {
        scrollView.setContentOffset(.zero, animated: true)
      }
    }
  }
  
  override func addUIComponents() {
    navPanelContainerHeight.isActive = false
    navPanelContainer.addSubview(navPanel)
    navPanel.fillToSuperview()
    
    vStack.addArrangedSubview(selectTypeButton)
    for index in 1...viewModel.countOfParticipants {
      let view = createParticipantBlock(with: index)
      vStack.addArrangedSubview(view)
    }
  }
  override func setupColorTheme() {
    navPanelContainer.backgroundColor = .clear
    scrollContainer.backgroundColor = .clear
    
    let gLayer = view.createGradientLayer(withColours: AppColor.backgroundGradientTwo, AppColor.backgroundGradientOne)
    vStackContainer.layer.insertSublayer(gLayer, at: 0)
    
    panelButtonContainer.backgroundColor = AppColor.layerOne
    panelButtonContainer.setShadow(with: Constants.containerTopRadius, and: AppColor.shadowOne)
    
    mainTitle.textColor = Constants.mainTitleColor
    additionalTitle.textColor = Constants.additionalTitleColor
    
    randomiseTitle.textColor = Constants.additionalTitleColor
    randomiseButton.setupEnabledBgColor(to: AppColor.layerSix)
    randomiseButton.setupCornerRadius(to: Constants.height / 2)
    randomiseButton.setupInnerShadow(with: AppColor.innerShadow)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
    
    randomiseTitle.font = Constants.itemTitleFont
    randomiseButton.setupFont(to: Constants.selectTypeGameFont)
  }
  override func setupLocalizeTitles() {
    mainTitle.text = NewGameTitles.createNew.localized
    additionalTitle.text = NewGameTitles.createNewMsg.localized
    
    randomiseTitle.text = NewGameTitles.randomiseTitle.localized
    randomiseButton.setupTitle(with: " " + NewGameTitles.randomise.localized)
    
    createButton.setupTitle(with: NewGameTitles.create.localized)
  }
  override func setupIcons() {
    randomiseButton.setupIcon(with: AppImage.NewGame.randomise)
  }
  override func setupConstraintsConstants() {
    panelButtonVStack.spacing = Constants.baseSideIndent
    panelButtonVStackTop.constant = Constants.baseSideIndent
    panelButtonVStackBottom.constant = Constants.baseSideIndent
    
    view.layoutIfNeeded() //for getting frames
    scrollContainerHeight.constant = expectedVStackHeight
    
    scrollViewBottom.constant = defaulScrollViewBottomIndent
    view.layoutIfNeeded() //for re-draw shadows
    
    randomiseButton.setupHeight(to: Constants.height)
  }
  override func additionalUISettings() {
    vStackContainer.cornerRadius = Constants.containerRadius
    
    panelButtonContainer.roundCorners([.topLeft, .topRight], radius: Constants.containerTopRadius)
    createButton.isEnabled = false
    
    selectTypeButton.isHidden = viewModel.readyToRandomize
    randomiseVStack.isHidden = !viewModel.readyToRandomize
  }
  
  //MARK: - Actions
  @IBAction func createButtonAction(_ sender: CommonButton) {
    guard viewModel.model.isReadyToCreateGame else { return }
    
    if !viewModel.readyToRandomize {
      AppCoordinator.shared.push(.newGameWith(viewModel.model))
    } else {
      popToRootVC()
      AppCoordinator.shared.push(.game(viewModel.model))
    }
  }
  @IBAction func randomiseButtonAction(_ sender: CommonButton) {
    var participants = viewModel.model.participants
    participants.shuffle()
    
    viewModel.participantPositionDidChange(with: participants)
  }
}
//MARK: - UI elements creating
private extension NewGameViewController {
  func createSelectTypeGameButtonTitle() -> UILabel {
    let label = UILabel()
    label.text = NewGameTitles.selectTypeGame.localized
    label.font = Constants.selectTypeGameFont
    label.textColor = Constants.selectTypeGameTextColor
    
    return label
  }
  func createSelectTypeGameButton() -> UIControl {
    let view = UIControl()
    view.backgroundColor = AppColor.layerSix
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    view.cornerRadius = Constants.radius
    
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = Constants.hStackSpacing
    hStack.isUserInteractionEnabled = false
    
    view.addSubview(hStack)
    hStack.fillToSuperview(horizontalIndents: 16.0)
    
    
    let imageView = UIImageView(image: AppImage.NewGame.iconType)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize.width).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize.height).isActive = true
    hStack.addArrangedSubview(imageView)
    
    hStack.addArrangedSubview(selectTypeButtonTitle)
    
    let imageView2 = UIImageView(image: AppImage.NewGame.arrowLeft)
    imageView2.translatesAutoresizingMaskIntoConstraints = false
    imageView2.widthAnchor.constraint(equalToConstant: Constants.iconSize.width).isActive = true
    imageView2.heightAnchor.constraint(equalToConstant: Constants.iconSize.height).isActive = true
    hStack.addArrangedSubview(imageView2)
    
    view.addTarget(self, action: #selector(setOpaqueButton), for: .touchDown)
    view.addTarget(self, action: #selector(setNonOpaquesButton), for: .touchDragExit)
    view.addTarget(self, action: #selector(setOpaqueButton), for: .touchDragEnter)
    view.addTarget(self, action: #selector(selectTypeButtonAction), for: .touchUpInside)
    
    return view
  }
  func createParticipantBlock(with number: Int) -> UIView {
    let view = UIView()
    
    let label = UILabel()
    label.text = String(format: NewGameTitles.participantName.localized, number)
    label.font = Constants.itemTitleFont
    label.textColor = Constants.itemTitleColor
    view.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: view.topAnchor, constant: .zero).isActive = true
    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
    
    let participantTF = ParticipantField.init(isSelectable: false, placeholder: NewGameTitles.participantNamePlaceholder.localized, delegate: self)
    participantTF.textField.delegate = self
    participantTF.textField.returnKeyType = .done
    participantTF.tag = number
    
    view.addSubview(participantTF)
    participantTF.translatesAutoresizingMaskIntoConstraints = false
    participantTF.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
    participantTF.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    participantTF.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    participantTF.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    return view
  }
}
//MARK: - SelectTypeGameButton Actions
private extension NewGameViewController {
  @objc private func setOpaqueButton() {
    updateButtonOpacity(true)
  }
  @objc private func setNonOpaquesButton() {
    updateButtonOpacity(false)
  }
  private func updateButtonOpacity(_ isOpaque: Bool) {
    selectTypeButton.layer.opacity = isOpaque ? Constants.actionsOpacity.highlighted : Constants.actionsOpacity.base
  }
  
  @objc func selectTypeButtonAction() {
    setNonOpaquesButton()
    
    AppCoordinator.shared.push(.typeNewGame(viewModel.model))
  }
}

//MARK: - CommonNavPanelDelegate
extension NewGameViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let tf = allParticipantFields.first(where: {$0.textField === textField})
    tf?.update(to: true)
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    let tf = allParticipantFields.first(where: {$0.textField === textField})
    tf?.update(to: false)
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = NewGameViewModel.maxSymbolsCount
    let currentString = (textField.text ?? "") as NSString
    let newString = currentString.replacingCharacters(in: range, with: string)
    let clearStr = newString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return clearStr.count <= maxLength
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let index = allParticipantFields.firstIndex { $0.textField === textField }
    
    guard let index else { return true }
    
    viewModel.fieldDidChange(value: textField.text, for: index)
    
    let nextTFIndex = allParticipantFields.index(after: index)
    
    
    if allParticipantFields.indices.contains(nextTFIndex) {
      allParticipantFields[nextTFIndex].textField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return false
  }
}
//MARK: - CommonNavPanelDelegate
extension NewGameViewController: CommonNavPanelDelegate {
  func backButtonAction() {
    popVC()
  }
}
//MARK: - ParticipantFieldDelegate
extension NewGameViewController: ParticipantFieldDelegate {
  func fieldValueDidChange(for participantField: ParticipantField) {
    guard let participantFieldIndex = allParticipantFields.firstIndex(of: participantField) else { return }
    
    viewModel.fieldDidChange(value: participantField.textField.text, for: participantFieldIndex)
  }
}
//MARK: - NewGameViewModelDelegate
extension NewGameViewController: NewGameViewModelDelegate {
  func validStateDidChange(to isValid: Bool) {
    createButton.isEnabled = isValid
  }
  func setupPreselectedValues(according model: NewGameModel) {
    if let gameType = model.gameType {
      selectTypeButtonTitle.text = gameType.title
      selectTypeButtonTitle.textColor = AppColor.accentOne
    }
    
    guard allParticipantFields.count == model.participants.count && model.isReadyToCreateGame else { return }
    
    if let gameType = model.gameType {
      navPanel.setupTitle(with: gameType.title)
    }
    
    createButton.isEnabled = model.isReadyToCreateGame
    
    guard viewModel.readyToRandomize else { return }
    for (index, participant) in model.participants.enumerated() {
      let participantField = allParticipantFields[index]
      participantField.textField.text = participant
      participantField.isUserInteractionEnabled = false
    }
  }
}
//MARK: - API
extension NewGameViewController {
  func updateModel(by gameType: GameType) {
    viewModel.gameTypeDidChange(to: gameType)
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static let actionsOpacity = TargetActionsOpacity()
  
  static var itemTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static let itemTitleColor: UIColor = AppColor.layerFour
  
  static var height: CGFloat {
    sizeProportion(for: 56.0, minSize: 44.0)
  }
  static var radius: CGFloat {
    sizeProportion(for: 16.0, minSize: 12.0)
  }
  static var containerRadius: CGFloat {
    sizeProportion(for: 24.0, minSize: 18.0)
  }
  
  static let iconSize: CGSize = .init(width: 24.0, height: 24.0)
  
  static var selectTypeGameFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  static let selectTypeGameTextColor = AppColor.layerOne
  
  static var hStackSpacing: CGFloat {
    sizeProportion(for: 8.0)
  }
  
  static var mainTitleFont: UIFont {
    let fontSize = sizeProportion(for: 20.0, minSize: 16.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static let mainTitleColor = AppColor.layerSix
  static var additionalTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static let additionalTitleColor = AppColor.layerTwo
  
  static var vStackContainerBottomConstraint: CGFloat {
    sizeProportion(for: 78.0)
  }
}
