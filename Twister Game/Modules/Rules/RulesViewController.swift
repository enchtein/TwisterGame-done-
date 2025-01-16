import UIKit

final class RulesViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var navPanelContainer: UIView!
  @IBOutlet weak var navPanelContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var scrollContainer: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentContainer: UIView!
  
  @IBOutlet weak var commonContentVStackTop: NSLayoutConstraint!
  @IBOutlet weak var commonContentVStackLeading: NSLayoutConstraint!
  @IBOutlet weak var commonContentVStackTrailing: NSLayoutConstraint!
  @IBOutlet weak var commonContentVStackBottom: NSLayoutConstraint!
  
  @IBOutlet weak var contentVStack: UIStackView!
  
  @IBOutlet weak var firstRulesTitle: UILabel!
  
  @IBOutlet weak var secondRulesFirstVStack: UIStackView!
  @IBOutlet weak var secondRulesFirstVStackTitle: UILabel!
  @IBOutlet weak var secondRulesFirstVStackVSubStack: UIStackView!
  @IBOutlet weak var secondRulesFirstVStackVSubStackTitle: UILabel!
  @IBOutlet weak var secondRulesFirstVStackVSubStackSubTitle: UILabel!
  
  @IBOutlet weak var secondRulesSecondVStack: UIStackView!
  @IBOutlet weak var secondRulesSecondVStackTitle: UILabel!
  @IBOutlet weak var secondRulesSecondVStackSubTitle: UILabel!
  
  @IBOutlet weak var secondRulesThirdVStack: UIStackView!
  @IBOutlet weak var secondRulesThirdVStackTitle: UILabel!
  @IBOutlet weak var secondRulesThirdVStackSubTitle: UILabel!
  
  @IBOutlet weak var enjoyGameHStack: UIStackView!
  @IBOutlet weak var enjoyGameHStackSpacer: UIView!
  @IBOutlet weak var enjoyGameHStackTitle: UILabel!
  
  @IBOutlet weak var contentVStackSpacer: UIView!
  
  private lazy var navPanel = CommonNavPanel.init(type: .rules, delegate: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollContainer.setInnerShadow(with: Constants.contentContainerRadius, and: AppColor.innerShadow)
  }
  
  override func addUIComponents() {
    navPanelContainerHeight.isActive = false
    navPanelContainer.addSubview(navPanel)
    navPanel.fillToSuperview()
  }
  override func setupColorTheme() {
    [navPanelContainer, scrollContainer, contentContainer, enjoyGameHStackSpacer, contentVStackSpacer].forEach {
      $0?.backgroundColor = .clear
    }
    
    firstRulesTitle.textColor = Constants.msgColor
    
    secondRulesFirstVStackTitle.textColor = Constants.titleColor
    secondRulesFirstVStackVSubStackTitle.textColor = Constants.subTitleColor
    secondRulesFirstVStackVSubStackSubTitle.textColor = Constants.msgColor
    
    secondRulesSecondVStackTitle.textColor = Constants.subTitleColor
    secondRulesSecondVStackSubTitle.textColor = Constants.msgColor
    
    secondRulesThirdVStackTitle.textColor = Constants.subTitleColor
    secondRulesThirdVStackSubTitle.textColor = Constants.msgColor
    
    enjoyGameHStackTitle.textColor = Constants.subTitleColor
  }
  override func setupFontTheme() {
    firstRulesTitle.font = Constants.msgFont
    
    secondRulesFirstVStackTitle.font = Constants.titleFont
    secondRulesFirstVStackVSubStackTitle.font = Constants.subTitleFont
    secondRulesFirstVStackVSubStackSubTitle.font = Constants.msgFont
    
    secondRulesSecondVStackTitle.font = Constants.subTitleFont
    secondRulesSecondVStackSubTitle.font = Constants.msgFont
    
    secondRulesThirdVStackTitle.font = Constants.subTitleFont
    secondRulesThirdVStackSubTitle.font = Constants.msgFont
    
    enjoyGameHStackTitle.font = Constants.titleFont
  }
  override func setupLocalizeTitles() {
    firstRulesTitle.text = RulesTitles.firstRulesMsg.localized
    
    secondRulesFirstVStackTitle.text = RulesTitles.secondRulesFirstVStackTitle.localized
    secondRulesFirstVStackVSubStackTitle.text = RulesTitles.secondRulesFirstVStackVSubStackTitle.localized
    secondRulesFirstVStackVSubStackSubTitle.text = RulesTitles.secondRulesFirstVStackVSubStackSubTitle.localized
    
    secondRulesSecondVStackTitle.text = RulesTitles.secondRulesSecondVStackTitle.localized
    secondRulesSecondVStackSubTitle.text = RulesTitles.secondRulesSecondVStackSubTitle.localized
    
    secondRulesThirdVStackTitle.text = RulesTitles.secondRulesThirdVStackTitle.localized
    secondRulesThirdVStackSubTitle.text = RulesTitles.secondRulesThirdVStackSubTitle.localized
    
    enjoyGameHStackTitle.text = RulesTitles.enjoyGameHStackTitle.localized
  }
  override func setupConstraintsConstants() {
    contentVStack.spacing = Constants.contentVStackSpacing
    secondRulesFirstVStack.spacing = Constants.secondRulesFirstVStackSpacing
    
    [commonContentVStackTop, commonContentVStackLeading, commonContentVStackTrailing, commonContentVStackBottom].forEach {
      $0?.constant = Constants.baseSideIndent
    }
  }
  override func additionalUISettings() {
    scrollView.showsVerticalScrollIndicator = false
  }
}

extension RulesViewController: CommonNavPanelDelegate {
  func backButtonAction() {
    popVC()
  }
  func shareButtonAction() {
    var rulesText: String = ""
    
    if let firstRulesTitle = firstRulesTitle.text {
      rulesText += firstRulesTitle + "\n\n"
    }
    
    
    if let secondRulesFirstVStackTitle = secondRulesFirstVStackTitle.text {
      rulesText += secondRulesFirstVStackTitle + "\n"
    }
    if let secondRulesFirstVStackVSubStackTitle = secondRulesFirstVStackVSubStackTitle.text {
      rulesText += secondRulesFirstVStackVSubStackTitle + "\n"
    }
    if let secondRulesFirstVStackVSubStackSubTitle = secondRulesFirstVStackVSubStackSubTitle.text {
      rulesText += secondRulesFirstVStackVSubStackSubTitle + "\n\n"
    }
    
    if let secondRulesSecondVStackTitle = secondRulesSecondVStackTitle.text {
      rulesText += secondRulesSecondVStackTitle + "\n"
    }
    if let secondRulesSecondVStackSubTitle = secondRulesSecondVStackSubTitle.text {
      rulesText += secondRulesSecondVStackSubTitle + "\n\n"
    }
    
    if let secondRulesThirdVStackTitle = secondRulesThirdVStackTitle.text {
      rulesText += secondRulesThirdVStackTitle + "\n"
    }
    if let secondRulesThirdVStackSubTitle = secondRulesThirdVStackSubTitle.text {
      rulesText += secondRulesThirdVStackSubTitle + "\n\n"
    }
    
    if let enjoyGameHStackTitle = enjoyGameHStackTitle.text {
      rulesText += enjoyGameHStackTitle
    }
    
    let shareVC = UIActivityViewController(activityItems: [rulesText, self] , applicationActivities: nil)
    present(shareVC, animated: true)
  }
}

fileprivate struct Constants: CommonSettings {
  static var titleFont: UIFont {
    let fontSize = sizeProportion(for: 20.0, minSize: 16.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static var subTitleFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  
  static var msgFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  
  static let titleColor = AppColor.layerThree
  static let subTitleColor = AppColor.layerOne
  
  static let msgColor = AppColor.layerTwo
  
  static var contentContainerRadius: CGFloat {
    Self.containerTopRadius / 2
  }
  
  static var contentVStackSpacing: CGFloat {
    sizeProportion(for: 24.0)
  }
  static var secondRulesFirstVStackSpacing: CGFloat {
    sizeProportion(for: 8.0)
  }
}
