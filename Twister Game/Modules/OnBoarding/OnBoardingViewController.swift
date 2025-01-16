import UIKit

final class OnBoardingViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
  
  @IBOutlet weak var goTwistButton: CommonButton!
  @IBOutlet weak var goTwistButtonTop: NSLayoutConstraint!
  @IBOutlet weak var goTwistButtonBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func setupColorTheme() {
    removeGradientLayer()
    view.backgroundColor = AppColor.accentOne
    [mainTitle, additionalTitle].forEach {
      $0?.textColor = AppColor.layerSix
    }
    
    goTwistButton.setupEnabledBgColor(to: AppColor.layerOne)
    goTwistButton.setupEnabledTitleColor(to: AppColor.layerSix)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
  }
  override func setupLocalizeTitles() {
    let attributedString = NSMutableAttributedString(string: OnBoardingTitles.mainStr.localized)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 0.75
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    mainTitle.attributedText = attributedString
    
    additionalTitle.text = OnBoardingTitles.additionalStr.localized
    
    goTwistButton.setupTitle(with: OnBoardingTitles.goTwist.localized)
  }
  override func setupIcons() {
    imageView.image = AppImage.OnBoarding.logo
  }
  override func setupConstraintsConstants() {
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    let bottomButtonWithIndent = goTwistButton.frame.height + goTwistButtonTop.constant + goTwistButtonBottom.constant
    let maxImageHeight = screenHeight - additionalTitle.frame.maxY - bottomButtonWithIndent - 24
    
    guard imageView.frame.height > maxImageHeight else { return }
    imageViewLeading.constant = (imageView.frame.height - maxImageHeight) / 2
  }
  
  //MARK: - Actions
  @IBAction func goTwistButtonAction(_ sender: CommonButton) {
    UserDefaults.standard.isWelcomeAlreadyAppeadred = true
    UserDefaults.standard.isAppSoundEnabled = true
    
    AppCoordinator.shared.activateRoot()
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var mainTitleFont: UIFont {
    let maxFontSize = 70.0
    let sizeProportion = maxFontSize.sizeProportion
    let fontSize = sizeProportion > maxFontSize ? maxFontSize : sizeProportion
    
    return AppFont.font(type: .maderaExtraBold, size: fontSize)
  }
  static var additionalTitleFont: UIFont {
    let maxFontSize = 16.0
    let sizeProportion = maxFontSize.sizeProportion
    let fontSize = sizeProportion > maxFontSize ? maxFontSize : sizeProportion
    
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
}
