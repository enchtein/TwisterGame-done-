import Foundation

enum AppViewController {
  case splashScreen
  case onBoarding
  
  case main
  case newGame(_ countOfParticipants: Int)
  case newGameWith(_ model: NewGameModel)
  case typeNewGame(_ model: NewGameModel)
  case rules
  case settings
  
  case game(_ model: NewGameModel?)
}
