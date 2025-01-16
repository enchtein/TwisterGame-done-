struct NewGameModel {
  let minSymbolsCount: Int
  let maxSymbolsCount: Int
  let countOfParticipants: Int
  
  let participants: [String]
  let gameType: GameType?
  
  var isValid: Bool {
    onlyValidParticipantsBySymbolsCount().count == countOfParticipants
  }
  var isReadyToCreateGame: Bool {
    gameType != nil && isValid
  }
  
  init(countOfParticipants: Int, minSymbols: Int, maxSymbols: Int) {
    self.countOfParticipants = countOfParticipants
    self.participants = Array(repeating: "", count: countOfParticipants)
    
    minSymbolsCount = minSymbols
    maxSymbolsCount = maxSymbols
    
    gameType = nil
  }
  init(participants: [String], basedOn model: Self) {
    self.participants = participants
    
    countOfParticipants = model.countOfParticipants
    minSymbolsCount = model.minSymbolsCount
    maxSymbolsCount = model.maxSymbolsCount
    gameType = model.gameType
  }
  init(gameType: GameType?, basedOn model: Self) {
    self.gameType = gameType
    
    participants = model.participants
    countOfParticipants = model.countOfParticipants
    minSymbolsCount = model.minSymbolsCount
    maxSymbolsCount = model.maxSymbolsCount
  }
  
  init(from gameModel: GameModel) {
    minSymbolsCount = NewGameViewModel.minSymbolsCount
    maxSymbolsCount = NewGameViewModel.maxSymbolsCount
    countOfParticipants = gameModel.participants.count
    
    participants = gameModel.participants.map { $0.name }
    gameType = gameModel.gameType
  }
  
  private func onlyValidParticipantsBySymbolsCount() -> [String] {
    participants.filter { $0.count >= minSymbolsCount && $0.count <= maxSymbolsCount }
  }
}
//MARK: - Mock
extension NewGameModel {
  static let empty: NewGameModel = .init(countOfParticipants: 0, minSymbols: 3 , maxSymbols: 20)
}
