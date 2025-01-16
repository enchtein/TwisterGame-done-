import UIKit

final class DisclamerViewController: CommonBasedOnPresentationViewController {
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var titlesVStackTop: NSLayoutConstraint!
  @IBOutlet weak var titlesVStackLeading: NSLayoutConstraint!
  @IBOutlet weak var titlesVStackTrailing: NSLayoutConstraint!
  
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  
  @IBOutlet weak var okButton: CommonButton!
  @IBOutlet weak var okButtonTop: NSLayoutConstraint!
  @IBOutlet weak var okButtonBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func setupColorTheme() {
    mainTitle.textColor = AppColor.accentOne
    additionalTitle.textColor = AppColor.layerTwo
    
    okButton.setupEnabledBgColor(to: AppColor.layerOne)
    okButton.setupEnabledTitleColor(to: AppColor.layerSix)
    okButton.setupShadowColor(to: AppColor.shadowOne)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
  }
  override func setupLocalizeTitles() {
    mainTitle.text = DisclamerTitles.mainTitle.localized
    additionalTitle.text = DisclamerTitles.additionalTitle.localized
    
    okButton.setupTitle(with: DisclamerTitles.okey.localized)
  }
  override func additionalUISettings() {
    //layout for correct calculating VC view height
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  @IBAction func okButtonAction(_ sender: CommonButton) {
    UserDefaults.standard.isDisclamerAlreadyAppeaded = true
    
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
}
