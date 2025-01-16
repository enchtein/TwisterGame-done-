import UIKit

@objc protocol CommonNavPanelDelegate: AnyObject {
  @objc optional func backButtonAction()
  
  @objc optional func exitGameButtonAction()
  @objc optional func statisticsButtonAction()
  @objc optional func shareButtonAction()
}
final class CommonNavPanel: UIView {
  private let type: NavPanelType
  private weak var delegate: CommonNavPanelDelegate?
  
  private lazy var commonHStack = createHStack()
  
  private lazy var backButton = createBackButton()
  private lazy var exitGameButton = createExitGameButton()
  private lazy var statisticsButton = createStatisticsButton()
  private lazy var shareButton = createShareButton()
  
  private lazy var title = createTitleLabel()
  private lazy var emptyView = createEmptyView()
  
  init(type: NavPanelType, delegate: CommonNavPanelDelegate) {
    self.type = type
    self.delegate = delegate
    
    super.init(frame: .zero)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(commonHStack)
    commonHStack.fillToSuperview(verticalIndents: Constants.baseSideIndent, horizontalIndents: Constants.baseSideIndent)
    
    switch type {
    case .game:
      commonHStack.addArrangedSubview(exitGameButton)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(statisticsButton)
    case .newGameCreation:
      commonHStack.addArrangedSubview(backButton)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(emptyView)
    case .typeNewGame:
      commonHStack.addArrangedSubview(backButton)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(emptyView)
    case .endGame:
      commonHStack.addArrangedSubview(emptyView)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(statisticsButton)
    case .rules:
      commonHStack.addArrangedSubview(backButton)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(shareButton)
    case .settings:
      commonHStack.addArrangedSubview(backButton)
      commonHStack.addArrangedSubview(title)
      commonHStack.addArrangedSubview(emptyView)
    }
  }
}
//MARK: - UI elements creating
private extension CommonNavPanel {
  func createHStack() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = Constants.hStackSpacing
    
    return stackView
  }
  
  func createBackButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.CommonNavPanel.back, for: .normal)
    button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    return button
  }
  func createExitGameButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.CommonNavPanel.exitGame, for: .normal)
    button.addTarget(self, action: #selector(exitGameButtonAction), for: .touchUpInside)
    return button
  }
  func createStatisticsButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.CommonNavPanel.statistics, for: .normal)
    button.addTarget(self, action: #selector(statisticsButtonAction), for: .touchUpInside)
    return button
  }
  func createShareButton() -> UIButton {
    let button = createButton()
    button.setImage(AppImage.CommonNavPanel.share, for: .normal)
    button.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    return button
  }
  
  func createTitleLabel() -> UILabel {
    let label = UILabel()
    label.textColor = AppColor.layerOne
    label.font = Constants.titleFont
    label.textAlignment = .center
    label.text = type.title
    
    return label
  }
}

//MARK: - UI Common elements creating
private extension CommonNavPanel {
  func createButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width).isActive = true
    button.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
    button.cornerRadius = Constants.buttonSize.height / 2.0
    button.backgroundColor = AppColor.layerSeven
    
    return button
  }
  func createEmptyView() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width).isActive = true
    view.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
    
    return view
  }
}
//MARK: - Helpers
private extension CommonNavPanel {
  @objc func backButtonAction() {
    delegate?.backButtonAction?()
  }
  
  @objc func exitGameButtonAction() {
    delegate?.exitGameButtonAction?()
  }
  @objc func statisticsButtonAction() {
    delegate?.statisticsButtonAction?()
  }
  @objc func shareButtonAction() {
    delegate?.shareButtonAction?()
  }
}
//MARK: - API
extension CommonNavPanel {
  func setupTitle(with text: String, animated: Bool = false) {
    if animated {
      UIView.transition(with: title, duration: animationDuration, options: .transitionCrossDissolve) {
        self.title.text = text
      }
    } else {
      title.text = text
    }
  }
  func updateBackButton(isHidden: Bool, animated: Bool = true) {
    UIView.animate(withDuration: animated ? self.animationDuration : .zero) {
      self.exitGameButton.alpha = isHidden ? 0.0 : 1.0
      self.exitGameButton.isUserInteractionEnabled = !isHidden
    }
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var hStackSpacing: CGFloat {
    sizeProportion(for: 8.0)
  }
  
  static var buttonSize: CGSize {
    let sideSize = sizeProportion(for: 56.0)
    return .init(width: sideSize, height: sideSize)
  }
  static var titleFont: UIFont {
    let fontSize = sizeProportion(for: 24.0)
    return AppFont.font(type: .maderaExtraBold, size: fontSize)
  }
}
//MARK: - NavPanelType
enum NavPanelType {
  case game
  case newGameCreation
  case typeNewGame
  case endGame
  case rules
  case settings
  
  var title: String {
    switch self {
    case .game: CommonNavPanelTitles.game.localized
    case .newGameCreation: CommonNavPanelTitles.newGameCreation.localized
    case .typeNewGame: CommonNavPanelTitles.typeNewGame.localized
    case .endGame: CommonNavPanelTitles.endGame.localized
    case .rules: CommonNavPanelTitles.rules.localized
    case .settings: CommonNavPanelTitles.settings.localized
    }
  }
}
