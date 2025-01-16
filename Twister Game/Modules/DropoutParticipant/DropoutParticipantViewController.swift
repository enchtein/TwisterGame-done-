import UIKit

final class DropoutParticipantViewController: CommonBasedOnPresentationViewController {
  @IBOutlet weak var contentVStack: UIStackView!
  @IBOutlet weak var contentVStackTop: NSLayoutConstraint!
  @IBOutlet weak var titlesVStack: UIStackView!
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var additionalTitle: UILabel!
  @IBOutlet weak var participantsVStack: UIStackView!
  
  
  @IBOutlet weak var buttonsVStack: UIStackView!
  @IBOutlet weak var buttonsVStackTop: NSLayoutConstraint!
  @IBOutlet weak var buttonsVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var applyButton: CommonButton!
  @IBOutlet weak var closeButton: CommonButton!
  
  
  var participants: [GameParticipantInfo] = []
  private var editableParticipants: [GameParticipantInfo] = []
  
  private var allParticipantFieldContainers: [ParticipantField] {
    participantsVStack.arrangedSubviews
      .filter { $0 is ParticipantField }
      .compactMap { $0 as? ParticipantField }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    editableParticipants = participants
  }
  
  override func addUIComponents() {
    participants.forEach {
      let view = createParticipantBlock(with: $0)
      view.update(to: $0.isOutOfGame)
      view.isEnabled = !$0.isOutOfGame
      participantsVStack.addArrangedSubview(view)
    }
  }
  override func setupColorTheme() {
    mainTitle.textColor = AppColor.accentOne
    additionalTitle.textColor = AppColor.layerTwo
    
    applyButton.setupEnabledBgColor(to: AppColor.layerOne)
    applyButton.setupEnabledTitleColor(to: AppColor.layerSix)
    applyButton.setupShadowColor(to: AppColor.shadowOne)
    
    closeButton.setupEnabledBgColor(to: .clear)
    closeButton.setupEnabledTitleColor(to: AppColor.layerFour)
  }
  override func setupFontTheme() {
    mainTitle.font = Constants.mainTitleFont
    additionalTitle.font = Constants.additionalTitleFont
    closeButton.setupFont(to: Constants.closeButtonFont)
  }
  override func setupLocalizeTitles() {
    mainTitle.text = DropoutParticipantTitles.mainTitle.localized
    additionalTitle.text = DropoutParticipantTitles.additionalTitle.localized
    
    applyButton.setupTitle(with: DropoutParticipantTitles.apply.localized)
    closeButton.setupTitle(with: DropoutParticipantTitles.close.localized)
  }
  override func setupConstraintsConstants() {
    closeButton.setupHeight(to: Constants.closeButtonHeight)
  }
  override func additionalUISettings() {
    applyButton.isEnabled = false // begin state
    
    //layout for correct calculating VC view height
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  //MARK: - Actions
  @IBAction func applyButtonAction(_ sender: CommonButton) {
    AppSoundManager.shared.dropoutParticipant()
    
    gameVC?.updateParticipantList(with: editableParticipants)
    dismiss(animated: true)
  }
  @IBAction func closeButtonAction(_ sender: CommonButton) {
    dismiss(animated: true)
  }
}
//MARK: - UI elements creating
private extension DropoutParticipantViewController {
  func createParticipantBlock(with participant: GameParticipantInfo) -> ParticipantField {
    let participantTF = ParticipantField.init(isSelectable: true, placeholder: NewGameTitles.participantNamePlaceholder.localized, delegate: self)
    participantTF.textField.text = participant.name
    
    let index = participants.firstIndex { $0 == participant }
    if let index {
      participantTF.tag = index
    }
    
    return participantTF
  }
}
//MARK: - ParticipantFieldDelegate
extension DropoutParticipantViewController: ParticipantFieldDelegate {
  func selectableButtonAction(for participantField: ParticipantField) {
    toggleOutOfGame(for: participantField)
  }
}
//MARK: - Helpers
private extension DropoutParticipantViewController {
  func toggleOutOfGame(for participantField: ParticipantField) {
    let participantIndex = participantField.tag
    guard editableParticipants.indices.contains(participantIndex) else { return }
    
    let participant = editableParticipants[participantIndex]
    let newValue = !participant.isOutOfGame
    
    editableParticipants[participantIndex] = GameParticipantInfo.init(isOutOfGame: newValue, basedOn: participant)
    participantField.update(to: newValue)
    
    
    //update apply button availability
    applyButton.isEnabled = newValue
    
    
    //deselect other participants
    guard newValue else { return }
    let orgOutOfGameParticipants = participants.filter { $0.isOutOfGame }
    let editableOutOfGameParticipants = editableParticipants.filter { $0.isOutOfGame }
    let shouldBeInGame = editableOutOfGameParticipants
      .filter { editableParticipants[participantIndex].id != $0.id }
      .filter { editable in
        !orgOutOfGameParticipants.contains { $0 == editable }
      }
    
    for shouldBeInGameParticipant in shouldBeInGame {
      let index = editableParticipants.firstIndex { $0 == shouldBeInGameParticipant }
      guard let index else { continue }
      guard editableParticipants.indices.contains(index) else { continue }
      
      editableParticipants[index] = GameParticipantInfo.init(isOutOfGame: false, basedOn: shouldBeInGameParticipant)
      allParticipantFieldContainers.filter{ $0.tag == index }.forEach {
        $0.update(to: false)
      }
    }
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
