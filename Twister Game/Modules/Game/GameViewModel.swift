import Foundation

protocol GameViewModelDelegate: AnyObject {
  func wheelStateDidChange(to state: WheelStateType)
  func nextParticipantIntervalDidChange(to value: Int)
  
  func currentParticipantDidChange(to model: GameParticipantInfo)
  func gameTypeDidChange(to type: GameType)
  
  func gameDidEnd(with winner: GameParticipantInfo)
}
final class GameViewModel {
  private weak var delegate: GameViewModelDelegate?
  private let newGameModel: NewGameModel?
  
  private(set) var model: GameModel = GameModel(participants: [], gameType: .classic)
  var gameType: GameType { model.gameType }
  private var inGameParticipants: [GameParticipantInfo] {
    model.participants.filter { !$0.isOutOfGame }
  }
  private(set) var state: WheelStateType = .readyToSpin
  
  let nextParticipantDefaultInterval: Int = 5 //5 sec of waiting
  private var nextParticipantInterval: Int = .zero //ost
  private var nextParticipantTimer: Timer?
  
  init(delegate: GameViewModelDelegate?, newGameModel: NewGameModel?) {
    self.delegate = delegate
    self.newGameModel = newGameModel
  }
  func viewDidLoad() {
    delegate?.wheelStateDidChange(to: state)
    setupPreselectedModel()
  }
  deinit {
#if DEBUG
    debugPrint("deinit GameViewModel")
#endif
  }
}
//MARK: - API
extension GameViewModel {
  func updateWheelState(to state: WheelStateType) {
    guard self.state != state else { return }
    self.state = state
    delegate?.wheelStateDidChange(to: state)
    
    if state == .nextParticipantWithTimer {
      scheduleNextParticipantTimer()
    }
  }
  
  func updateParticipantsAndRunChecking(with newList: [GameParticipantInfo]) {
    //1) update participants arr in model
    newList.forEach {
      updateModelParticipants(with: $0)
    }
    
    //2) update current participant in model
    if let currentParticipant  = model.currentParticipant {
      let updatedCurrentParticipant = newList.first { $0 == currentParticipant }
      if let updatedCurrentParticipant {
        let updatedModel = GameModel.init(currentParticipant: updatedCurrentParticipant, basedOn: model)
        updateModel(with: updatedModel)
      }
    }
    
    //3) game checkings
    if inGameParticipants.count > 1 {
      guard let currentParticipant  = model.currentParticipant else { return }
      let isCurrentParticipantOut = currentParticipant.isOutOfGame
      
      guard isCurrentParticipantOut else { return }
      
      let currentParticipantIndex = model.participants.firstIndex { $0 == currentParticipant }
      guard let currentParticipantIndex else { return }
      let nextParticipant = model.participants[currentParticipantIndex...].first { !$0.isOutOfGame }
      
      if let nextParticipant {
        let updatedModel = GameModel.init(currentParticipant: nextParticipant, basedOn: model)
        updateModel(with: updatedModel)
        
        delegate?.currentParticipantDidChange(to: nextParticipant)
      } else {
        guard let nextParticipant = inGameParticipants.first else { return }
        
        let updatedModel = GameModel.init(currentParticipant: nextParticipant, basedOn: model)
        updateModel(with: updatedModel)
        
        delegate?.currentParticipantDidChange(to: nextParticipant)
      }
      
      nextParticipantTimer?.invalidate()
      updateWheelState(to: .readyToSpin)
    } else {
      guard let winner = inGameParticipants.first else { return }
      
      let updatedWinner = GameParticipantInfo.init(roundWins: winner.roundWins + 1, basedOn: winner)
      updateModelParticipants(with: updatedWinner)
      
      delegate?.gameDidEnd(with: winner)
    }
  }
  
  func nextParticipantTurn() {
    switchToNextParticipant() //1)
    updateWheelState(to: .readyToSpin) //2)
  }
  
  func restartGame() {
    let updatedParticipants = model.participants.map {
      GameParticipantInfo.init(name: $0.name, roundWins: $0.roundWins)
    }
    
    let restartModel = GameModel.init(participants: updatedParticipants, basedOn: model)
    
    if let firstParticipant = restartModel.participants.first {
      let updatedModel = GameModel.init(currentParticipant: firstParticipant, basedOn: restartModel)
      updateModel(with: updatedModel)
      
      delegate?.currentParticipantDidChange(to: firstParticipant)
    } else {
      updateModel(with: restartModel)
    }
    
    updateWheelState(to: .readyToSpin)
  }
  func finishGame() {
    UserDefaults.standard.savedGameData = nil
  }
}
//MARK: - Helpers (Timer)
private extension GameViewModel {
  func scheduleNextParticipantTimer() {
    nextParticipantTimer?.invalidate()
    
    nextParticipantInterval = nextParticipantDefaultInterval
    nextParticipantTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(nextParticipant), userInfo: nil, repeats: true)
  }
  
  @objc func nextParticipant() {
    if nextParticipantInterval > 1 {
      nextParticipantInterval -= 1
      delegate?.nextParticipantIntervalDidChange(to: nextParticipantInterval)
    } else {
      nextParticipantTimer?.invalidate()
      nextParticipantTimer = nil
      updateWheelState(to: .nextParticipant)
    }
  }
}
//MARK: - Helpers
private extension GameViewModel {
  func setupPreselectedModel() {
    if let newGameModel {
      //new game
      model = GameModel.init(from: newGameModel)
    } else {
      //game from UserDefaults
      restoreGame()
    }
    delegate?.gameTypeDidChange(to: model.gameType)
    
    if let currentParticipant = model.currentParticipant {
      delegate?.currentParticipantDidChange(to: currentParticipant)
    } else {
      guard let firstParticipant = model.participants.first else { return }
      let updatedModel = GameModel.init(currentParticipant: firstParticipant, basedOn: model)
      updateModel(with: updatedModel)
      
      delegate?.currentParticipantDidChange(to: firstParticipant)
    }
    
    updateWheelState(to: .readyToSpin)
  }
  
  func switchToNextParticipant() {
    let availableParticipants = inGameParticipants
    guard availableParticipants.count > .zero else { return }
    
    let nextPartciipantIndex: Int
    if let currentParticipant = model.currentParticipant {
      let currentParticipantIndex = availableParticipants.firstIndex { $0 == currentParticipant }
      if let currentParticipantIndex {
        let nextIndex = availableParticipants.index(after: currentParticipantIndex)
        nextPartciipantIndex = availableParticipants.indices.contains(nextIndex) ? nextIndex : .zero
      } else {
        nextPartciipantIndex = .zero
      }
      
      increaseScore(for: currentParticipant)
    } else {
      nextPartciipantIndex = .zero
    }
    
    let nextParticipant = availableParticipants[nextPartciipantIndex]
    let updatedModel = GameModel.init(currentParticipant: nextParticipant, basedOn: model)
    updateModel(with: updatedModel)
    
    delegate?.currentParticipantDidChange(to: nextParticipant)
  }
  func increaseScore(for participant: GameParticipantInfo) {
    let updatedParticipant = GameParticipantInfo.init(score: participant.score + 1, basedOn: participant)
    
    updateModelParticipants(with: updatedParticipant)
  }
  
  func updateModelParticipants(with updatedParticipant: GameParticipantInfo) {
    var updatedParticipants = [GameParticipantInfo]()
    for participant in model.participants {
      if participant == updatedParticipant {
        updatedParticipants.append(updatedParticipant)
      } else {
        updatedParticipants.append(participant)
      }
    }
    
    let updatedModel = GameModel.init(participants: updatedParticipants, basedOn: model)
    updateModel(with: updatedModel)
  }
  
  func updateModel(with updatedModel: GameModel) {
    model = updatedModel
    saveGame()
  }
}
//MARK: - Helpers (savedGameData)
private extension GameViewModel {
  func saveGame() {
    let jsonData = try? JSONEncoder().encode(model)
    UserDefaults.standard.savedGameData = jsonData
  }
  func restoreGame() {
    guard let existGameData = UserDefaults.standard.savedGameData else { return }
    let restoredModel = try? JSONDecoder().decode(GameModel.self, from: existGameData)
    
    guard let restoredModel else { return }
    model = restoredModel
  }
}
