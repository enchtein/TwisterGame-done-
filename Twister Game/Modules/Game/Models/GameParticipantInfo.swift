import Foundation

struct GameParticipantInfo: Codable {
  let id: UUID
  
  let name: String
  let score: Int //at game
  let roundWins: Int //count of winning games
  
  let isOutOfGame: Bool
  
  private init(name: String, score: Int, roundWins: Int, isOutOfGame: Bool, id: UUID) {
    self.name = name
    self.score = score
    self.roundWins = roundWins
    self.isOutOfGame = isOutOfGame
    self.id = id
  }
  
  static func == (lhs: GameParticipantInfo, rhs: GameParticipantInfo) -> Bool {
    lhs.id == rhs.id
  }
}
//MARK: - init helpers
extension GameParticipantInfo {
  init(name: String, score: Int) {
    self.init(name: name, score: score, roundWins: 0, isOutOfGame: false, id: UUID())
  }
  
  init(score: Int, basedOn model: Self) {
    self.init(name: model.name,
              score: score,
              roundWins: model.roundWins,
              isOutOfGame: model.isOutOfGame,
              id: model.id)
  }
  init(isOutOfGame: Bool, basedOn model: Self) {
    self.init(name: model.name,
              score: model.score,
              roundWins: model.roundWins,
              isOutOfGame: isOutOfGame,
              id: model.id)
  }
  init(roundWins: Int, basedOn model: Self) {
    self.init(name: model.name,
              score: model.score,
              roundWins: roundWins,
              isOutOfGame: model.isOutOfGame,
              id: model.id)
  }
  
  init(name: String, roundWins: Int) {
    self.name = name
    self.score = 0
    self.roundWins = roundWins
    self.isOutOfGame = false
    self.id = UUID()
  }
}
