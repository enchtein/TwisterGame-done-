import UIKit

final class MainViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var topTitlesVStack: UIStackView!
  @IBOutlet weak var topTitlesVStackTop: NSLayoutConstraint!
  @IBOutlet weak var gradientTitle: GradientLabel!
  @IBOutlet weak var subTitle: UILabel!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageViewTop: NSLayoutConstraint!
  
  @IBOutlet weak var buttonBarContainer: UIView!
  @IBOutlet weak var buttonBarHStack: UIStackView!
  @IBOutlet weak var buttonBarHStackTop: NSLayoutConstraint!
  @IBOutlet weak var buttonBarHStackBottom: NSLayoutConstraint!
  @IBOutlet weak var ruleButton: CommonButton!
  @IBOutlet weak var settingButton: CommonButton!
  private var buttonsBar: [CommonButton] {
    [ruleButton, settingButton]
  }
  
  @IBOutlet weak var panelPlayers: UIView!
  @IBOutlet weak var panelPlayersParticipantsHStack: UIStackView!
  @IBOutlet weak var panelPlayersParticipantsHStackTop: NSLayoutConstraint!
  @IBOutlet weak var panelPlayersParticipantsHStackBottom: NSLayoutConstraint!
  @IBOutlet weak var participantsTitle: UILabel!
  @IBOutlet weak var participantsButtonsHStack: UIStackView!
  @IBOutlet weak var twoPlayersButton: CommonButton!
  @IBOutlet weak var threePlayersButton: CommonButton!
  @IBOutlet weak var fourPlayersButton: CommonButton!
  private var participantButtons: [CommonButton] {
    [twoPlayersButton, threePlayersButton, fourPlayersButton]
  }
  @IBOutlet weak var panelButtonContainer: UIView!
  @IBOutlet weak var panelButtonContainerTitlesVStack: UIStackView!
  @IBOutlet weak var panelButtonContainerTitlesVStackTop: NSLayoutConstraint!
  @IBOutlet weak var panelButtonContainerTitlesVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var panelButtonTitle: UILabel!
  @IBOutlet weak var panelButtonSubTitle: UILabel!
  @IBOutlet weak var startNewGameButton: CommonButton!
  @IBOutlet weak var startNewGameButtonBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    checkToDisclamer()
    checkToRestoreGame()
  }
  
  override func setupColorTheme() {
    gradientTitle.gradientColors = [AppColor.oneGL, AppColor.oneGL, AppColor.oneGL, AppColor.oneGL, AppColor.twoGL, AppColor.twoGL, AppColor.threeGL, AppColor.threeGL, AppColor.fourGL, AppColor.fiveGL, AppColor.sixGL, AppColor.sevenGL, AppColor.eightGL, AppColor.nineGL, AppColor.nineGL].map { $0.cgColor }
    subTitle.textColor = AppColor.layerOne
    
    buttonBarContainer.backgroundColor = .clear
    
    [ruleButton, settingButton].forEach {
      $0?.setupHeight(to: Constants.participantsButtonsHeight)
      $0?.setupCornerRadius(to: Constants.participantsButtonsRadius)
      $0?.setupShadowColor(to: .clear)
      
      $0?.setupEnabledTitleColor(to: AppColor.layerOne)
      $0?.setupEnabledBgColor(to: AppColor.layerSix)
      $0?.setupBorderColor(to: AppColor.layerFive)
      $0?.setupInnerShadow(with: AppColor.innerShadow)
    }
    
    panelPlayers.backgroundColor = AppColor.accentOne
    panelPlayers.roundCorners([.topLeft, .topRight], radius: Constants.containerTopRadius)
    
    participantsTitle.textColor = AppColor.layerOne
    
    participantButtons.forEach {
      $0.setupHeight(to: Constants.participantsButtonsHeight)
      $0.setupCornerRadius(to: Constants.participantsButtonsRadius)
      
      $0.setupEnabledBgColor(to: AppColor.layerThree)
      $0.setupEnabledTitleColor(to: AppColor.layerOne)
      $0.setupShadowColor(to: .clear)
    }
    
    panelButtonContainer.backgroundColor = AppColor.layerOne
    panelButtonContainer.setShadow([.topLeft, .topRight], with: Constants.containerTopRadius, and: AppColor.shadowOne)
    
    panelButtonTitle.textColor = AppColor.layerSix
    panelButtonSubTitle.textColor = AppColor.layerTwo
  }
  override func setupFontTheme() {
    gradientTitle.font = Constants.gradientTitleFont
    subTitle.font = Constants.subTitleFont
    
    [ruleButton, settingButton].forEach {
      $0?.setupFont(to: Constants.buttonBarFont)
    }
    
    participantsTitle.font = Constants.participantsTitleFont
    participantButtons.forEach {
      $0.setupFont(to: Constants.participantsButtonsFont)
      $0.setupTitle(titleEdgeInsets: Constants.participantsButtonsTitleInsets)
    }
    
    panelButtonTitle.font = Constants.panelButtonTitleFont
    panelButtonSubTitle.font = Constants.panelButtonSubTitleFont
  }
  override func setupLocalizeTitles() {
    gradientTitle.text = MainTitles.gradientTitle.localized
    subTitle.text = MainTitles.subTitle.localized
    
    ruleButton.setupTitle(with: " " + MainTitles.rules.localized)
    ruleButton.setupIcon(with: AppImage.Main.rules)
    settingButton.setupTitle(with: " " + MainTitles.settings.localized)
    settingButton.setupIcon(with: AppImage.Main.settings)
    
    
    participantsTitle.text = MainTitles.participants.localized
    twoPlayersButton.setupTitle(with: "2")
    threePlayersButton.setupTitle(with: "3")
    fourPlayersButton.setupTitle(with: "4")
    
    panelButtonTitle.text = MainTitles.newGame.localized
    panelButtonSubTitle.text = MainTitles.newGameMsg.localized
    startNewGameButton.setupTitle(with: MainTitles.startNewGame.localized)
  }
  override func setupIcons() {
    imageView.image = AppImage.Main.main
  }
  override func setupConstraintsConstants() {
    imageViewTop.constant = Constants.imageViewTop
    panelPlayersParticipantsHStackBottom.constant = Constants.halfBaseSideIndent
    
    [topTitlesVStackTop, buttonBarHStackTop, buttonBarHStackBottom, panelPlayersParticipantsHStackTop, panelButtonContainerTitlesVStackTop, panelButtonContainerTitlesVStackBottom, startNewGameButtonBottom].forEach {
      $0?.constant = Constants.baseSideIndent
    }
  }
  override func additionalUISettings() {
    updateSelectedParticipants(to: fourPlayersButton)
  }
  
  //MARK: - Actions
  @IBAction func ruleButtonAction(_ sender: CommonButton) {
    AppCoordinator.shared.push(.rules)
  }
  @IBAction func settingButtonAction(_ sender: CommonButton) {
    AppCoordinator.shared.push(.settings)
  }
  
  @IBAction func playerButtonAction(_ sender: CommonButton) {
    updateSelectedParticipants(to: sender)
  }
  
  @IBAction func startNewGameButtonAction(_ sender: CommonButton) {
    let selectedButtonText = participantButtons.first { $0.enabledBgColor == AppColor.layerOne }?.titleLabel?.text
    guard let selectedButtonText, let value = Int(selectedButtonText) else { return }
    AppCoordinator.shared.push(.newGame(value))
  }
}

//MARK: - Helpers (UI)
private extension MainViewController {
  func updateSelectedParticipants(to selectedButton: CommonButton) {
    let unSelectedButtons = participantButtons.filter { $0 !== selectedButton }
    
    let animationDuration = isAppeared ? Constants.animationDuration : .zero
    UIView.animate(withDuration: animationDuration) {
      for button in unSelectedButtons {
        button.setupEnabledBgColor(to: AppColor.layerThree)
        button.setupEnabledTitleColor(to: AppColor.layerOne)
        button.setupShadowColor(to: .clear)
      }
      
      selectedButton.setupEnabledBgColor(to: AppColor.layerOne)
      selectedButton.setupEnabledTitleColor(to: AppColor.accentOne)
      selectedButton.setupShadowColor(to: AppColor.shadowOne)
    }
  }
}
//MARK: - Helpers
private extension MainViewController {
  func checkToDisclamer() {
    guard !UserDefaults.standard.isDisclamerAlreadyAppeaded else { return }
    
    let vc = DisclamerViewController.createFromNibHelper()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    
    present(vc, animated: true)
  }
  func checkToRestoreGame() {
    guard UserDefaults.standard.savedGameData != nil else { return }
    
    let vc = ContinueGameViewController.createFromNibHelper()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    
    present(vc, animated: true)
  }
}
//MARK: - API
extension MainViewController {
  func restoreGameAction() {
    AppCoordinator.shared.push(.game(nil))
  }
  func clearStoredGameAction() {
    UserDefaults.standard.savedGameData = nil
  }
}
//MARK: - UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    if presented is ContinueGameViewController {
      ContinueGamePresentationController(presentedViewController: presented, presenting: presenting)
    } else if presented is DisclamerViewController {
      DisclamerPresentationController(presentedViewController: presented, presenting: presenting)
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
  
  static var participantsButtonsHeight: CGFloat {
    sizeProportion(for: 56.0)
  }
  static var participantsButtonsRadius: CGFloat {
    participantsButtonsHeight / 2
  }
  static var participantsButtonsFont: UIFont {
    let fontSize = sizeProportion(for: 24.0)
    return AppFont.font(type: .maderaExtraBold, size: fontSize)
  }
  static var participantsButtonsTitleInsets: UIEdgeInsets {
    let bottomIndent = sizeProportion(for: 7.0)
    return UIEdgeInsets(top: 0, left: 0, bottom: bottomIndent, right: 0)
  }
  
  static var buttonBarFont: UIFont {
    let fontSize = sizeProportion(for: 18.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  
  static var participantsTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  
  static var panelButtonTitleFont: UIFont {
    let fontSize = sizeProportion(for: 20.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static var panelButtonSubTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  
  static var imageViewTop: CGFloat { sizeProportion(for: 20.0) }
  static var halfBaseSideIndent: CGFloat { baseSideIndent / 2 }
}
