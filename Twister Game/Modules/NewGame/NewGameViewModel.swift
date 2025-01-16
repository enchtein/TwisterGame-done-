protocol NewGameViewModelDelegate: AnyObject {
  func validStateDidChange(to isValid: Bool)
  func setupPreselectedValues(according model: NewGameModel)
}
final class NewGameViewModel {
  private weak var delegate: NewGameViewModelDelegate?
  
  private(set) var model: NewGameModel = .empty
  private let orgGameType: GameType?
  var readyToRandomize: Bool { orgGameType != nil }
  
  let countOfParticipants: Int
  static let minSymbolsCount: Int = 3
  static let maxSymbolsCount: Int = 20
  
  convenience init(countOfParticipants: Int, model: NewGameModel?, delegate: NewGameViewModelDelegate?) {
    if let model {
      self.init(model: model, delegate: delegate)
    } else {
      self.init(countOfParticipants: countOfParticipants, delegate: delegate)
    }
  }
  private init(countOfParticipants: Int, delegate: NewGameViewModelDelegate?) {
    self.delegate = delegate
    self.countOfParticipants = countOfParticipants
    
    model = NewGameModel.init(countOfParticipants: countOfParticipants, minSymbols: Self.minSymbolsCount, maxSymbols: Self.maxSymbolsCount)
    orgGameType = nil
  }
  private init(model: NewGameModel, delegate: NewGameViewModelDelegate?) {
    self.delegate = delegate
    self.countOfParticipants = model.countOfParticipants
    
    self.model = model
    self.orgGameType = model.gameType
  }
  
  func viewDidLoad() {
    delegate?.setupPreselectedValues(according: model)
  }
  
  func fieldDidChange(value: String?, for index: Int) {
    let value = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    
    var participants = model.participants
    guard participants.indices.contains(index) else { return }
    participants[index] = value
    
    model = NewGameModel(participants: participants, basedOn: model)
    delegate?.validStateDidChange(to: model.isReadyToCreateGame)
  }
  
  func participantPositionDidChange(with array: [String]) {
    model = NewGameModel(participants: array, basedOn: model)
    
    delegate?.setupPreselectedValues(according: model)
  }
  func gameTypeDidChange(to gameType: GameType) {
    model = NewGameModel(gameType: gameType, basedOn: model)
    
    delegate?.setupPreselectedValues(according: model)
  }
}
