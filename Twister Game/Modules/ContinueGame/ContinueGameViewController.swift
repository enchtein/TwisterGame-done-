import UIKit

final class ContinueGameViewController: CommonBasedOnPresentationViewController {
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var titlesVStackTop: NSLayoutConstraint!
  
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  
  @IBOutlet weak var buttonsVStack: UIStackView!
  @IBOutlet weak var buttonsVStackTop: NSLayoutConstraint!
  @IBOutlet weak var buttonsVStackBottom: NSLayoutConstraint!
  
  @IBOutlet weak var continueButton: CommonButton!
  @IBOutlet weak var closeButton: CommonButton!
  
  private var mainVC: MainViewController? {
    transitioningDelegate as? MainViewController
  }
  
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
    
    closeButton.setupEnabledBgColor(to: .clear)
    closeButton.setupEnabledTitleColor(to: AppColor.layerFour)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
    closeButton.setupFont(to: Constants.closeButtonFont)
  }
  override func setupLocalizeTitles() {
    mainTitle.text = ContinueGameTitles.main.localized
    additionalTitle.text = ContinueGameTitles.additional.localized
    continueButton.setupTitle(with: ContinueGameTitles.continueText.localized)
    closeButton.setupTitle(with: ContinueGameTitles.close.localized)
  }
  override func setupConstraintsConstants() {
    closeButton.setupHeight(to: Constants.closeButtonHeight)
  }
  override func additionalUISettings() {
    //layout for correct calculating VC view height
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  //MARK: - Actions
  @IBAction func continueButtonAction(_ sender: CommonButton) {
    mainVC?.restoreGameAction()
    dismiss(animated: true)
  }
  @IBAction func closeButtonAction(_ sender: CommonButton) {
    mainVC?.clearStoredGameAction()
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
  
  static var closeButtonFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  static var closeButtonHeight: CGFloat {
    24.0
  }
}
