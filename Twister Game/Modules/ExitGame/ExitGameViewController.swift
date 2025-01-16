import UIKit

final class ExitGameViewController: CommonBasedOnPresentationViewController {
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var titlesVStackTop: NSLayoutConstraint!
  
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  
  @IBOutlet weak var buttonsVStack: UIStackView!
  @IBOutlet weak var buttonsVStackTop: NSLayoutConstraint!
  @IBOutlet weak var buttonsVStackBottom: NSLayoutConstraint!
  
  @IBOutlet weak var continueButton: CommonButton!
  @IBOutlet weak var exitButton: CommonButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func setupColorTheme() {
    mainTitle.textColor = AppColor.accentOne
    additionalTitle.textColor = AppColor.layerTwo
    
    continueButton.setupEnabledBgColor(to: AppColor.layerOne)
    continueButton.setupEnabledTitleColor(to: AppColor.layerSix)
    continueButton.setupShadowColor(to: AppColor.shadowOne)
    
    exitButton.setupEnabledBgColor(to: .clear)
    exitButton.setupEnabledTitleColor(to: AppColor.layerFour)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
    
    exitButton.setupFont(to: Constants.exitButtonFont)
  }
  override func setupLocalizeTitles() {
    mainTitle.text = ExitGameTitles.mainTitle.localized
    additionalTitle.text = ExitGameTitles.additionalTitle.localized
    
    continueButton.setupTitle(with: ExitGameTitles.continueText.localized)
    exitButton.setupTitle(with: ExitGameTitles.exit.localized)
  }
  override func setupConstraintsConstants() {
    exitButton.setupHeight(to: 24.0)
  }
  override func additionalUISettings() {
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  //MARK: - Actions
  @IBAction func continueButtonAction(_ sender: CommonButton) {
    dismiss(animated: true)
  }
  @IBAction func exitButtonAction(_ sender: CommonButton) {
    gameVC?.exitGameAction()
    dismiss(animated: true)
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var mainTitleFont: UIFont {
    let fontSize = sizeProportion(for: 24.0)
    return AppFont.font(type: .maderaExtraBold, size: fontSize)
  }
  static var additionalTitleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  
  static var exitButtonFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
}
