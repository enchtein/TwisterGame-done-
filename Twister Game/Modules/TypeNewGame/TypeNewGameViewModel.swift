import Foundation

protocol TypeNewGameViewModelDelegate: AnyObject {
  func didTapCell(at indexPath: IndexPath)
  func updateSelectButton(isEnabled: Bool)
}
final class TypeNewGameViewModel {
  private weak var delegate: TypeNewGameViewModelDelegate?
  
  private var model: NewGameModel = .empty
  var selectedGameType: GameType? { model.gameType }
  
  let dataSource: [GameType] = GameType.allCases
  
  init(model: NewGameModel, delegate: TypeNewGameViewModelDelegate?) {
    self.model = model
    self.delegate = delegate
  }
  
  func viewDidLoad() {
    delegate?.updateSelectButton(isEnabled: model.gameType != nil)
  }
}
//MARK: - API
extension TypeNewGameViewModel {
  func didTapCell(at indexPath: IndexPath) {
    guard let gameType = gameType(for: indexPath) else { return }
    if model.gameType == gameType {
      model = NewGameModel.init(gameType: nil, basedOn: model)
    } else {
      model = NewGameModel.init(gameType: gameType, basedOn: model)
    }
    
    delegate?.didTapCell(at: indexPath)
    delegate?.updateSelectButton(isEnabled: model.gameType != nil)
  }
}
//MARK: - API (DataSource)
extension TypeNewGameViewModel {
  func numberOfSections() -> Int {
    1
  }
  func numberOfItems(in section: Int) -> Int {
    dataSource.count
  }
  func gameType(for indexPath: IndexPath) -> GameType? {
    guard isExistGameType(at: indexPath) else { return nil }
    
    let index = index(from: indexPath)
    return dataSource[index]
  }
  
  func isFirstCell(at indexPath: IndexPath) -> Bool {
    dataSource.indices.first == index(from: indexPath)
  }
  func isSelectedCell(at indexPath: IndexPath) -> Bool {
    guard let cellType = gameType(for: indexPath) else { return false }
    return model.gameType == cellType
  }
  func isLastCell(at indexPath: IndexPath) -> Bool {
    dataSource.indices.last == index(from: indexPath)
  }
}
//MARK: - Helpers (DataSource)
private extension TypeNewGameViewModel {
  func index(from indexPath: IndexPath) -> Int {
    indexPath.row
  }
  func indexPath(from index: Int) -> IndexPath {
    IndexPath(row: index, section: 0)
  }
  func isExistGameType(at indexPath: IndexPath) -> Bool {
    let index = index(from: indexPath)
    return dataSource.indices.contains(index)
  }
}
