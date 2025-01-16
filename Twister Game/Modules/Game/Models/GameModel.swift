struct GameModel: Codable {
  let participants: [GameParticipantInfo]
  let gameType: GameType
  
  let currentParticipant: GameParticipantInfo?
  
  private init(participants: [GameParticipantInfo], gameType: GameType, currentParticipant: GameParticipantInfo?) {
    self.participants = participants
    self.gameType = gameType
    self.currentParticipant = currentParticipant
  }
}
//MARK: - init helpers
extension GameModel {
  init(participants: [GameParticipantInfo], gameType: GameType) {
    self.init(participants: participants,
              gameType: gameType,
              currentParticipant: nil)
  }
  init(participants: [GameParticipantInfo], basedOn model: Self) {
    self.init(participants: participants,
              gameType: model.gameType,
              currentParticipant: model.currentParticipant)
  }
  init(currentParticipant: GameParticipantInfo, basedOn model: Self) {
    self.init(participants: model.participants,
              gameType: model.gameType,
              currentParticipant: currentParticipant)
  }
  
  init(from newGameModel: NewGameModel) {
    let participantsInfo = newGameModel.participants.map {
      GameParticipantInfo.init(name: $0, score: 0)
    }
    self.init(participants: participantsInfo, gameType: newGameModel.gameType ?? .classic)
  }
}
