enum GameType: Int, CaseIterable, Codable {
  case classic = 0
  case teams
  case championship
  
  var title: String {
    switch self {
    case .classic: NewGameTitles.classic.localized
    case .teams: NewGameTitles.teams.localized
    case .championship: NewGameTitles.championship.localized
    }
  }
  var description: String {
    switch self {
    case .classic: NewGameTitles.classicDescr.localized
    case .teams: NewGameTitles.teamsDescr.localized
    case .championship: NewGameTitles.championshipDescr.localized
    }
  }
  
  var endGameSubtitle: String {
    switch self {
    case .classic, .teams: GameTitles.endGameSubTitle.localized
    case .championship: GameTitles.endChampionshipGameSubTitle.localized
    }
  }
}
