import UIKit

final class StatisticsGameViewController: CommonBasedOnPresentationViewController {
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var titlesVStackTop: NSLayoutConstraint!
  
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  
  
  @IBOutlet weak var participantsInfoVStack: UIStackView!
  @IBOutlet weak var participantsInfoVStackTop: NSLayoutConstraint!
  
  @IBOutlet weak var titlesHStack: UIStackView!
  @IBOutlet weak var participantTitle: UILabel!
  @IBOutlet weak var turnTitle: UILabel!
  @IBOutlet weak var turnTitleWidth: NSLayoutConstraint!
  @IBOutlet weak var winsTitle: UILabel!
  @IBOutlet weak var dividerView: UIView!
  @IBOutlet weak var statisticsVStack: UIStackView!
  
  
  @IBOutlet weak var buttonsHStack: UIStackView!
  @IBOutlet weak var buttonsHStackTop: NSLayoutConstraint!
  @IBOutlet weak var buttonsHStackBottom: NSLayoutConstraint!
  @IBOutlet weak var closeButton: CommonButton!
  @IBOutlet weak var shareButton: CommonButton!
  
  var statisticsVStackMinHStackHeight: CGFloat {
    statisticsVStack.arrangedSubviews.min { $0.frame.height < $1.frame.height }?.frame.height ?? 0
  }
  
  var gameModel: GameModel?
  private var participants: [GameParticipantInfo] {
    gameModel?.participants ?? []
  }
  private var isWinsLabelsNeeded: Bool {
    participants.contains { $0.roundWins > 0 }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func addUIComponents() {
    participants.forEach { participant in
      let hStack = createHStack()
      statisticsVStack.addArrangedSubview(hStack)
      
      let nameLabel = createNameLabel(for: participant)
      hStack.addArrangedSubview(nameLabel)
      
      let turnLabel = createTurnLabel(for: participant)
      hStack.addArrangedSubview(turnLabel)
      turnLabel.translatesAutoresizingMaskIntoConstraints = false
      turnLabel.widthAnchor.constraint(equalTo: turnTitle.widthAnchor, multiplier: 1.0).isActive = true
      
      if isWinsLabelsNeeded {
        let winsLabel = createWinsLabel(for: participant)
        hStack.addArrangedSubview(winsLabel)
        
        winsLabel.translatesAutoresizingMaskIntoConstraints = false
        winsLabel.widthAnchor.constraint(equalTo: winsTitle.widthAnchor, multiplier: 1.0).isActive = true
      }
    }
  }
  override func setupColorTheme() {
    mainTitle.textColor = AppColor.accentOne
    additionalTitle.textColor = AppColor.layerTwo
    
    [participantTitle, turnTitle, winsTitle].forEach {
      $0?.textColor = AppColor.layerFour
    }
    
    dividerView.backgroundColor = AppColor.layerSeven
    
    closeButton.setupEnabledBgColor(to: AppColor.layerOne)
    closeButton.setupEnabledTitleColor(to: AppColor.layerSix)
    closeButton.setupShadowColor(to: AppColor.shadowOne)
    
    shareButton.setupEnabledBgColor(to: .clear)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
    
    [participantTitle, turnTitle, winsTitle].forEach {
      $0?.font = Constants.otherTitleFont
    }
  }
  override func setupLocalizeTitles() {
    mainTitle.text = StatisticsGameTitles.mainTitle.localized
    additionalTitle.text = StatisticsGameTitles.additionalTitle.localized
    
    participantTitle.text = StatisticsGameTitles.participant.localized
    turnTitle.text = StatisticsGameTitles.turn.localized
    winsTitle.text = StatisticsGameTitles.wins.localized
    
    closeButton.setupTitle(with: StatisticsGameTitles.close.localized)
  }
  override func setupIcons() {
    shareButton.setupTitle(with: "")
    shareButton.setupIcon(with: AppImage.StatisticsGame.share)
  }
  override func setupConstraintsConstants() {
    turnTitleWidth.isActive = isWinsLabelsNeeded
  }
  override func additionalUISettings() {
    winsTitle.isHidden = !isWinsLabelsNeeded
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  //MARK: - Actions
  @IBAction func closeButtonAction(_ sender: CommonButton) {
    dismiss(animated: true)
  }
  @IBAction func shareButtonAction(_ sender: CommonButton) {
    guard let snapshot = view.takeScreenshot() else { return }
    
    let shareVC = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
    shareVC.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    present(shareVC, animated: true)
  }
}
//MARK: - UI elements creating
private extension StatisticsGameViewController {
  func createHStack() -> UIStackView {
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.spacing = 16.0
    
    return hStack
  }
  
  func createNameLabel(for participant: GameParticipantInfo) -> UILabel {
    let nameLabel = UILabel()
    nameLabel.font = Constants.labelFont
    nameLabel.textColor = participant.isOutOfGame ? AppColor.layerFour : AppColor.layerOne
    nameLabel.textAlignment = .left
    nameLabel.text = participant.name
    
    return nameLabel
  }
  func createTurnLabel(for participant: GameParticipantInfo) -> UILabel {
    let turnLabel = UILabel()
    turnLabel.font = Constants.labelFont
    turnLabel.textAlignment = .center
    turnLabel.textColor = AppColor.accentOne
    turnLabel.text = participant.isOutOfGame ? StatisticsGameTitles.out.localized : String(participant.score)
    
    return turnLabel
  }
  func createWinsLabel(for participant: GameParticipantInfo) -> UILabel {
    let winsLabel = UILabel()
    winsLabel.font = Constants.labelFont
    winsLabel.textAlignment = .center
    winsLabel.textColor = AppColor.accentOne
    winsLabel.text = String(participant.roundWins)
    
    return winsLabel
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
  static var otherTitleFont: UIFont { additionalTitleFont }
  
  static var labelFont: UIFont {
    let fontSize = sizeProportion(for: 20.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
}

//MARK: - get screenshot of view
fileprivate extension UIView {
  func takeScreenshot() -> UIImage? {
    // Begin context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
    
    // Draw view in that context
    drawHierarchy(in: self.bounds, afterScreenUpdates: true)
    
    // And finally, get image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}
