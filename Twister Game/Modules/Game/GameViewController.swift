import UIKit

final class GameViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var navPanelContainer: UIView!
  @IBOutlet weak var navPanelContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var titlesContainer: UIView!
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var mainTitlesVStack: UIStackView!
  @IBOutlet weak var gradientTitle: GradientLabel!
  @IBOutlet weak var subTitle: UILabel!
  @IBOutlet weak var additionalTitlesHStack: UIStackView!
  @IBOutlet weak var yourTurnTitle: UILabel!
  @IBOutlet weak var bodyActionLabel: UILabel!
  @IBOutlet weak var sectionColorNameLabel: UILabel!
  @IBOutlet weak var dotTitle: UILabel!
  
  @IBOutlet weak var panelBottom: UIView!
  
  @IBOutlet weak var panelBottomButtonsVStack: UIStackView!
  @IBOutlet weak var panelBottomButtonsVStackTop: NSLayoutConstraint!
  @IBOutlet weak var panelBottomButtonsVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var panelBottomButtonsTitle: UILabel!
  @IBOutlet weak var dropoutButton: CommonButton!
  @IBOutlet weak var spinOrNextButton: CommonButton!
  
  @IBOutlet weak var wheelContainer: UIView!
  @IBOutlet weak var wheelContainerBottom: NSLayoutConstraint!
  
  @IBOutlet weak var endGameVStack: UIStackView!
  @IBOutlet weak var endGameVStackTop: NSLayoutConstraint!
  @IBOutlet weak var endGameTitle: UILabel!
  @IBOutlet weak var endGameSubTitle: UILabel!
  @IBOutlet weak var endGameButtonsVStack: UIStackView!
  @IBOutlet weak var restartOrContinueGameButton: CommonButton!
  @IBOutlet weak var goToMainButton: CommonButton!
  private lazy var endGameVStackBottom = createEndGameVStackBottom()
  
  private lazy var navPanel = CommonNavPanel.init(type: .game, delegate: self)
  private lazy var wheel = TwisterWheel.init(delegate: self)
  
  var newGameModel: NewGameModel?
  private lazy var viewModel = GameViewModel(delegate: self, newGameModel: newGameModel)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel.viewDidLoad()
  }
  
  override func addUIComponents() {
    navPanelContainerHeight.isActive = false
    navPanelContainer.addSubview(navPanel)
    navPanel.fillToSuperview()
    
    wheelContainer.addSubview(wheel)
    wheel.fillToSuperview()
  }
  override func setupColorTheme() {
    navPanelContainer.backgroundColor = .clear
    
    titlesContainer.backgroundColor = .clear
    gradientTitle.gradientColors = [AppColor.oneGL, AppColor.oneGL, AppColor.oneGL, AppColor.oneGL, AppColor.twoGL, AppColor.twoGL, AppColor.threeGL, AppColor.threeGL, AppColor.fourGL, AppColor.fiveGL, AppColor.sixGL, AppColor.sevenGL, AppColor.eightGL, AppColor.nineGL, AppColor.nineGL].map { $0.cgColor }
    subTitle.textColor = AppColor.layerFour
    
    [yourTurnTitle, bodyActionLabel, dotTitle].forEach {
      $0?.textColor = AppColor.layerOne
    }
    
    panelBottom.backgroundColor = AppColor.layerOne
    wheelContainer.backgroundColor = .clear
    
    panelBottomButtonsTitle.textColor = AppColor.layerTwo
    
    dropoutButton.setupEnabledBgColor(to: AppColor.layerOne)
    spinOrNextButton.setupShadowColor(to: AppColor.shadowOne)
    
    endGameTitle.textColor = AppColor.layerSix
    endGameSubTitle.textColor = AppColor.layerTwo
    
    restartOrContinueGameButton.setupShadowColor(to: AppColor.shadowOne)
    goToMainButton.setupEnabledBgColor(to: AppColor.layerOne)
    goToMainButton.setupShadowColor(to: .clear)
    goToMainButton.setupBorderColor(to: AppColor.layerTwo)
    goToMainButton.setupEnabledTitleColor(to: AppColor.layerSix)
  }
  override func setupFontTheme() {
    gradientTitle.font = Constants.gradientTitleFont
    subTitle.font = Constants.subTitleFont
    
    [yourTurnTitle, bodyActionLabel, sectionColorNameLabel, dotTitle].forEach {
      $0?.font = Constants.additionalTitlesHStackLabelsFont
    }
    
    panelBottomButtonsTitle.font = Constants.subTitleFont
    
    endGameTitle.font = Constants.additionalTitlesHStackLabelsFont
    endGameSubTitle.font = Constants.subTitleFont
  }
  override func setupLocalizeTitles() {
    gradientTitle.text = "Participant name"
    subTitle.text = GameTitles.participant.localized
    yourTurnTitle.text = GameTitles.yourTurn.localized + ": "
    panelBottomButtonsTitle.text = GameTitles.panelBottomButtonsTitle.localized
    
    endGameTitle.text = GameTitles.endGameTitle.localized
    endGameSubTitle.text = GameTitles.endGameSubTitle.localized
  }
  override func setupIcons() {
    dropoutButton.setupTitle(with: "")
    dropoutButton.setupIcon(with: AppImage.Game.removeParticipant)
  }
  override func setupConstraintsConstants() {
    [panelBottomButtonsVStack, endGameVStack].forEach {
      $0?.spacing = Constants.baseSideIndent
    }
    
    [endGameVStackTop, panelBottomButtonsVStackTop, panelBottomButtonsVStackBottom].forEach {
      $0?.constant = Constants.baseSideIndent
    }
  }
  override func additionalUISettings() {
    panelBottom.roundCorners([.topLeft, .topRight], radius: Constants.containerTopRadius)
    setupOpacityForEndOfGameElements(isHidden: true)
    additionalTitlesHStack.hideAnimated(in: titlesVStack)
  }
  
  @IBAction func dropoutButtonAction(_ sender: CommonButton) {
    AppSoundManager.shared.buttonTap()
    
    let vc = DropoutParticipantViewController.createFromNibHelper()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    
    vc.participants = viewModel.model.participants
    
    present(vc, animated: true)
  }
  @IBAction func spinOrNextButtonAction(_ sender: CommonButton) {
    AppSoundManager.shared.buttonTap()
    
    switch viewModel.state {
    case .readyToSpin:
      wheel.rotateWheel()
    case .nextParticipant:
      additionalTitlesHStack.hideAnimated(in: titlesVStack)
      viewModel.nextParticipantTurn()
    default: break
    }
  }
  
  @IBAction func restartOrContinueGameButtonAction(_ sender: CommonButton) {
    AppSoundManager.shared.buttonTap()
    
    switch viewModel.gameType {
    case .classic, .teams:
      popToRootVC()
      
      viewModel.finishGame()
      let newGameModel = NewGameModel.init(from: viewModel.model)
      AppCoordinator.shared.push(.newGameWith(newGameModel))
    case .championship:
      viewModel.restartGame()
      //show back button in panel
      navPanel.updateBackButton(isHidden: false)
      updateUIToRestartGame()
    }
  }
  @IBAction func goToMainButtonAction(_ sender: CommonButton) {
    AppSoundManager.shared.buttonTap()
    
    exitGameAction()
  }
}
//MARK: - CommonNavPanelDelegate
extension GameViewController: CommonNavPanelDelegate {
  func exitGameButtonAction() {
    let vc = ExitGameViewController.createFromNibHelper()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    
    present(vc, animated: true)
  }
  func statisticsButtonAction() {
    let vc = StatisticsGameViewController.createFromNibHelper()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    vc.gameModel = viewModel.model
    
    present(vc, animated: true)
  }
}
//MARK: - TwisterWheelDelegate
extension GameViewController: TwisterWheelDelegate {
  func wheelStartRotating() {
    viewModel.updateWheelState(to: .spinning)
  }
  func wheelEndRotating() {
    viewModel.updateWheelState(to: .nextParticipantWithTimer)
  }
  
  func selectedTwisterWheelSectionDidChange(_ sectionModel: TwisterSectionModel) {
    additionalTitlesHStack.showAnimated(in: titlesVStack)
    
    UIView.transition(with: bodyActionLabel, duration: view.animationDuration, options: .transitionCrossDissolve) {
      self.bodyActionLabel.text = sectionModel.type.fullTitle + " - "
    }
    UIView.transition(with: sectionColorNameLabel, duration: view.animationDuration, options: .transitionCrossDissolve) {
      self.sectionColorNameLabel.text = sectionModel.colorType.title
      self.sectionColorNameLabel.textColor = sectionModel.colorType.color
    }
  }
}
//MARK: - GameViewModelDelegate
extension GameViewController: GameViewModelDelegate {
  func wheelStateDidChange(to state: WheelStateType) {
    switch state {
    case .readyToSpin:
      spinOrNextButton.setupTitle(with: GameTitles.spin.localized, animated: true)
    case .spinning:
      spinOrNextButton.setupTitle(with: GameTitles.spinning.localized + "...", animated: true)
    case .nextParticipantWithTimer:
      spinOrNextButton.setupTitle(with: String(format: GameTitles.nextParticipantWithSeconds.localized, viewModel.nextParticipantDefaultInterval), animated: true)
    case .nextParticipant:
      spinOrNextButton.setupTitle(with: GameTitles.nextParticipant.localized, animated: true)
    }
    
    spinOrNextButton.isEnabled = state == .readyToSpin || state == .nextParticipant
  }
  
  func nextParticipantIntervalDidChange(to value: Int) {
    spinOrNextButton.isEnabled = false
    spinOrNextButton.setupTitle(with: String(format: GameTitles.nextParticipantWithSeconds.localized, value))
  }
  
  func currentParticipantDidChange(to model: GameParticipantInfo) {
    additionalTitlesHStack.hideAnimated(in: titlesVStack)
    
    let transformStartDuration = view.animationDuration * 0.4
    let transformEndDuration = view.animationDuration * 0.6
    
    UIView.animate(withDuration: transformStartDuration) {
      self.gradientTitle.transform = .init(scaleX: 1.25, y: 1.25)
    } completion: { _ in
      self.gradientTitle.text = model.name
      UIView.animate(withDuration: transformEndDuration) {
        self.gradientTitle.transform = .identity
      }
    }
  }
  func gameTypeDidChange(to type: GameType) {
    endGameSubTitle.text = type.endGameSubtitle
    
    let restartOrContinueGameButtonTitle = type == .championship ? GameTitles.continueGame.localized : GameTitles.restartGame.localized
    restartOrContinueGameButton.setupTitle(with: restartOrContinueGameButtonTitle)
    let goToMainButtonTitle = type == .championship ? GameTitles.finishAndGoToMain.localized : GameTitles.goToMain.localized
    goToMainButton.setupTitle(with: goToMainButtonTitle)
  }
  
  func gameDidEnd(with winner: GameParticipantInfo) {
    AppSoundManager.shared.gameWin()
    
    currentParticipantDidChange(to: winner)
    subTitle.text = GameTitles.winner.localized
    
    additionalTitlesHStack.hideAnimated(in: titlesVStack)
    
    updateUIToEndOfGame()
    
    //hide back button in panel
    navPanel.updateBackButton(isHidden: true)
  }
}
//MARK: - Helpers
private extension GameViewController {
  func createEndGameVStackBottom() -> NSLayoutConstraint? {
    guard let endGameVStack, let panelBottom else { return nil }
    return NSLayoutConstraint.init(item: endGameVStack, attribute: .bottom, relatedBy: .equal,
                                   toItem: panelBottom, attribute: .bottom, multiplier: 1.0,
                                   constant: -Constants.baseSideIndent)
  }
  func createWheelContainerBottom() -> NSLayoutConstraint? {
    guard let wheelContainer, let panelBottom else { return nil }
    return NSLayoutConstraint.init(item: wheelContainer, attribute: .bottom, relatedBy: .equal,
                                   toItem: panelBottom, attribute: .bottom, multiplier: 1.0,
                                   constant: .zero)
  }
  
  func updateUIToEndOfGame() {
    navPanel.setupTitle(with: NavPanelType.endGame.title, animated: true)
    
    wheelContainerBottom.isActive = false
    endGameVStackBottom?.isActive = true
    
    setupOpacityForEndOfGameElements(isHidden: false)
    
    UIView.animate(withDuration: view.animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  func updateUIToRestartGame() {
    navPanel.setupTitle(with: NavPanelType.game.title, animated: true)
    
    endGameVStackBottom?.isActive = false
    wheelContainerBottom = createWheelContainerBottom()
    wheelContainerBottom.isActive = true
    
    setupOpacityForEndOfGameElements(isHidden: true)
    
    UIView.animate(withDuration: view.animationDuration) {
      self.view.layoutIfNeeded()
    }
    
    subTitle.text = GameTitles.participant.localized
    
    //spin to start position
    wheel.restartWheel()
  }
  func setupOpacityForEndOfGameElements(isHidden: Bool) {
    if isHidden {
      endGameVStack.fadeOut()
      
      panelBottomButtonsVStack.fadeIn()
      wheelContainer.fadeIn()
    } else {
      endGameVStack.fadeIn()
      
      panelBottomButtonsVStack.fadeOut()
      wheelContainer.fadeOut()
    }
    
    endGameVStack.isUserInteractionEnabled = !isHidden
    panelBottomButtonsVStack.isUserInteractionEnabled = isHidden
    wheelContainer.isUserInteractionEnabled = isHidden
  }
}
//MARK: - API
extension GameViewController {
  func updateParticipantList(with participants: [GameParticipantInfo]) {
    viewModel.updateParticipantsAndRunChecking(with: participants)
  }
  func exitGameAction() {
    viewModel.finishGame()
    popToRootVC()
  }
}
//MARK: - UIViewControllerTransitioningDelegate
extension GameViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    if presented is DropoutParticipantViewController {
      DropoutParticipantPresentationController(presentedViewController: presented, presenting: presenting)
    } else if presented is ExitGameViewController {
      ExitGamePresentationController(presentedViewController: presented, presenting: presenting)
    } else if presented is StatisticsGameViewController {
      StatisticsGamePresentationController(presentedViewController: presented, presenting: presenting)
    } else {
      nil
    }
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var gradientTitleFont: UIFont {
    let fontSize = sizeProportion(for: 40.0)
    return AppFont.font(type: .maderaExtraBold, size: fontSize)
  }
  static var subTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static var additionalTitlesHStackLabelsFont: UIFont {
    let fontSize = sizeProportion(for: 20.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
}
