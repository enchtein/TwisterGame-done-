import UIKit

final class TypeNewGameViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var navPanelContainer: UIView!
  @IBOutlet weak var navPanelContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
  
  @IBOutlet weak var panelButtonContainer: UIView!
  @IBOutlet weak var panelButtonVStack: UIStackView!
  @IBOutlet weak var panelButtonVStackTop: NSLayoutConstraint!
  @IBOutlet weak var panelButtonVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var panelButtonTitle: UILabel!
  @IBOutlet weak var panelButtonHelperTitle: UILabel!
  @IBOutlet weak var panelButtonSelectButton: CommonButton!
  
  var model: NewGameModel = .empty
  
  private lazy var navPanel = CommonNavPanel.init(type: .typeNewGame, delegate: self)
  private lazy var viewModel = TypeNewGameViewModel.init(model: model, delegate: self)
  
  private var newGameVC: NewGameViewController? {
    AppCoordinator.shared.child(before: self) as? NewGameViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: TypeNewGameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TypeNewGameTableViewCell.identifier)
    viewModel.viewDidLoad()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if !isAppeared {
      tableView.reloadData()
    }
  }
  
  override func addUIComponents() {
    navPanelContainerHeight.isActive = false
    navPanelContainer.addSubview(navPanel)
    navPanel.fillToSuperview()
  }
  override func setupColorTheme() {
    navPanelContainer.backgroundColor = .clear
    tableView.backgroundColor = .clear
    
    panelButtonContainer.backgroundColor = Constants.panelButtonContainerColor
    panelButtonTitle.textColor = Constants.selectTypeGameColor
    panelButtonHelperTitle.textColor = Constants.selectTypeGameHelperColor
  }
  override func setupFontTheme() {
    panelButtonTitle.font = Constants.selectTypeGameFont
    panelButtonHelperTitle.font = Constants.selectTypeGameHelperFont
  }
  override func setupLocalizeTitles() {
    panelButtonTitle.text = TypeNewGameTitles.panelButtonTitle.localized
    panelButtonHelperTitle.text = TypeNewGameTitles.panelButtonHelperTitle.localized
    panelButtonSelectButton.setupTitle(with: TypeNewGameTitles.select.localized)
  }
  override func setupConstraintsConstants() {
    tableViewBottom.constant = -Constants.baseSideIndent
    tableView.contentInset.bottom = Constants.baseSideIndent * 2
    
    tableView.showsVerticalScrollIndicator = false
    
    panelButtonVStack.spacing = Constants.baseSideIndent
    panelButtonVStackTop.constant = Constants.baseSideIndent
    panelButtonVStackBottom.constant = Constants.baseSideIndent
  }
  override func additionalUISettings() {
    panelButtonContainer.roundCorners([.topLeft, .topRight], radius: Constants.containerTopRadius)
  }
  //MARK: - Actions
  @IBAction func panelButtonSelectButtonAction(_ sender: CommonButton) {
    guard let selectedGameType = viewModel.selectedGameType else { return }
    newGameVC?.updateModel(by: selectedGameType)
    
    popVC()
  }
}
//MARK: - UITableViewDataSource
extension TypeNewGameViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSections()
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfItems(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let type = viewModel.gameType(for: indexPath)
    if let type, let cell = tableView.dequeueReusableCell(withIdentifier: TypeNewGameTableViewCell.identifier, for: indexPath) as? TypeNewGameTableViewCell {
      let isSelected = viewModel.isSelectedCell(at: indexPath)
      let isFirst = viewModel.isFirstCell(at: indexPath)
      let isLast = viewModel.isLastCell(at: indexPath)
      
      cell.setupUI(with: type, isSelected: isSelected, isFirst: isFirst, isLast: isLast, delegate: self)
      
      return cell
    } else {
      return UITableViewCell()
    }
  }
}
//MARK: - UITableViewDelegate
extension TypeNewGameViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
//MARK: - TypeNewGameTableViewCellDelegate
extension TypeNewGameViewController: TypeNewGameTableViewCellDelegate {
  func didSelect(cell: TypeNewGameTableViewCell) {
    guard let cellIndexPath = tableView.indexPath(for: cell) else { return }
    viewModel.didTapCell(at: cellIndexPath)
  }
}
//MARK: - TypeNewGameViewModelDelegate
extension TypeNewGameViewController: TypeNewGameViewModelDelegate {
  func didTapCell(at indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? TypeNewGameTableViewCell else { return }
    
    cell.updateUIAccording(isSelected: viewModel.isSelectedCell(at: indexPath))
    
    let otherCellIndethPaths = tableView.indexPathsForVisibleRows?.filter{ $0 != indexPath }
    otherCellIndethPaths?.forEach {
      (tableView.cellForRow(at: $0) as? TypeNewGameTableViewCell)?.updateUIAccording(isSelected: false)
    }
  }
  func updateSelectButton(isEnabled: Bool) {
    panelButtonSelectButton.isEnabled = isEnabled
  }
}
//MARK: - CommonNavPanelDelegate
extension TypeNewGameViewController: CommonNavPanelDelegate {
  func backButtonAction() {
    popVC()
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  
  static let panelButtonContainerColor = AppColor.layerOne
  static var selectTypeGameFont: UIFont {
    let fontSize = sizeProportion(for: 20.0, minSize: 16.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static let selectTypeGameColor = AppColor.layerSix
  
  static var selectTypeGameHelperFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static let selectTypeGameHelperColor = AppColor.layerTwo
}
