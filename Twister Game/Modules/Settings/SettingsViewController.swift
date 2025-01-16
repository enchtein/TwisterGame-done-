import UIKit
import StoreKit

final class SettingsViewController: BaseViewController, StoryboardInitializable {
  @IBOutlet weak var navPanelContainer: UIView!
  @IBOutlet weak var navPanelContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentContainer: UIView!
  
  private lazy var navPanel = CommonNavPanel.init(type: .settings, delegate: self)
  
  private lazy var commonVStack = createCommonVStack()
  private lazy var contentVStack = createContentVStack()
  
  private var allSections: [UIView] {
    contentVStack.arrangedSubviews
  }
  private var allItemViews: [UIControl] {
    allSections
      .compactMap { $0.subviews }.joined()
      .compactMap { $0 as? UIStackView }
      .map { $0.arrangedSubviews }
      .joined()
      .compactMap { $0 as? UIControl }
  }
  private var toggleSwitchControl: UIControl? {
    allItemViews.first { tappedItemType(for: $0) == .sound }
  }
  private var soundToggleSwitch: UISwitch? {
    toggleSwitchControl?.subviews.first { $0 is UISwitch } as? UISwitch
  }
  
  private var dataSource: [[SettingType]] {
    [SettingType.firstSection, SettingType.secondSection, SettingType.thirdSection]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    allSections.forEach {
      let gLayerTag = "gLayer"
      let gLayer = $0.createGradientLayer(withColours: AppColor.backgroundGradientTwo, AppColor.backgroundGradientOne)
      gLayer.name = gLayerTag
      
      $0.removeLayer(with: gLayerTag)
      
      $0.layer.insertSublayer(gLayer, at: 0)
      
      $0.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    }
    allItemViews.forEach {
      $0.setInnerShadow(with: Constants.radius, and: AppColor.innerShadow)
    }
  }
  
  override func addUIComponents() {
    navPanelContainerHeight.isActive = false
    navPanelContainer.addSubview(navPanel)
    navPanel.fillToSuperview()
    
    //setup items
    contentVStack.addArrangedSubview(createFirstSettingsPart())
    contentVStack.addArrangedSubview(createSecondSettingsPart())
    contentVStack.addArrangedSubview(createThirdSettingsPart())
    
    contentContainer.addSubview(commonVStack)
    commonVStack.fillToSuperview()
  }
  override func setupColorTheme() {
    navPanelContainer.backgroundColor = .clear
    contentContainer.backgroundColor = .clear
  }
  override func additionalUISettings() {
    soundToggleSwitch?.isOn = UserDefaults.standard.isAppSoundEnabled
  }
}
//MARK: - UI elements creating
private extension SettingsViewController {
  func createCommonVStack() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = .zero
    
    let spacer = UIView()
    spacer.backgroundColor = .clear
    
    stackView.addArrangedSubview(contentVStack)
    stackView.addArrangedSubview(spacer)
    
    return stackView
  }
  func createContentVStack() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Constants.baseSideIndent
    return stackView
  }
  
  func createSettingButton(for type: SettingType) -> UIControl {
    let view = UIControl()
    view.tag = type.rawValue
    view.backgroundColor = AppColor.layerSix
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    view.cornerRadius = Constants.radius
    
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = Constants.hStackSpacing
    hStack.isUserInteractionEnabled = false
    
    view.addSubview(hStack)
    hStack.fillToSuperview(horizontalIndents: 16.0)
    
    
    let imageView = UIImageView(image: type.image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize.width).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize.height).isActive = true
    hStack.addArrangedSubview(imageView)
    
    let label = UILabel()
    label.text = type.title
    label.font = Constants.itemFont
    label.textColor = Constants.itemTextColor
    hStack.addArrangedSubview(label)
    
    let imageView2 = UIImageView(image: AppImage.NewGame.arrowLeft)
    imageView2.translatesAutoresizingMaskIntoConstraints = false
    imageView2.widthAnchor.constraint(equalToConstant: Constants.iconSize.width).isActive = true
    imageView2.heightAnchor.constraint(equalToConstant: Constants.iconSize.height).isActive = true
    hStack.addArrangedSubview(imageView2)
    
    
    if type == .sound {
      let toggleSwitch = UISwitch()
      toggleSwitch.isOn = true
      toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
      toggleSwitch.transform = CGAffineTransform(scaleX: Constants.toggleSwitchScaleFactor, y: Constants.toggleSwitchScaleFactor)
      toggleSwitch.onTintColor = Constants.toggleSwitchOnTintColor
      toggleSwitch.thumbTintColor = Constants.toggleSwitchThumbTintColor
      
      let vLineView = UIView()
      vLineView.backgroundColor = Constants.toggleSwitchThumbTintColor
      vLineView.translatesAutoresizingMaskIntoConstraints = false
      vLineView.heightAnchor.constraint(equalToConstant: Constants.toggleSwitchLineHeight).isActive = true
      vLineView.widthAnchor.constraint(equalToConstant: Constants.toggleSwitchLineWidth).isActive = true
      toggleSwitch.addSubview(vLineView)
      vLineView.leadingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: Constants.toggleSwitchLineHeight).isActive = true
      vLineView.centerYAnchor.constraint(equalTo: toggleSwitch.centerYAnchor).isActive = true
      
      view.addSubview(toggleSwitch)
      toggleSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      toggleSwitch.trailingAnchor.constraint(equalTo: hStack.trailingAnchor).isActive = true
      
      toggleSwitch.isUserInteractionEnabled = false
    }
    
    
    view.addTarget(self, action: #selector(setOpaqueButton), for: .touchDown)
    view.addTarget(self, action: #selector(setNonOpaquesButton), for: .touchDragExit)
    view.addTarget(self, action: #selector(setOpaqueButton), for: .touchDragEnter)
    view.addTarget(self, action: #selector(selectTypeButtonAction), for: .touchUpInside)
    
    return view
  }
  func createFirstSettingsPart() -> UIView {
    let items = SettingType.firstSection.map { createSettingButton(for: $0) }
    
    let verLabel = UILabel()
    verLabel.textAlignment = .center
    verLabel.text = String(format: SettingsTitles.verApp.localized, appVer)
    verLabel.textColor = Constants.verTextColor
    verLabel.font = Constants.verFont
    
    let vStack = createSectionVStack(with: items + [verLabel])
    
    return createSectionContainer(with: vStack)
  }
  func createSecondSettingsPart() -> UIView {
    let items = SettingType.secondSection.map { createSettingButton(for: $0) }
    let vStack = createSectionVStack(with: items)
    
    return createSectionContainer(with: vStack)
  }
  func createThirdSettingsPart() -> UIView {
    let items = SettingType.thirdSection.map { createSettingButton(for: $0) }
    let vStack = createSectionVStack(with: items)
    
    return createSectionContainer(with: vStack)
  }
  func createSectionVStack(with subviews: [UIView]) -> UIStackView {
    let sectionVStack = UIStackView(arrangedSubviews: subviews)
    sectionVStack.axis = .vertical
    sectionVStack.spacing = 8
    
    return sectionVStack
  }
  func createSectionContainer(with vStack: UIStackView) -> UIView {
    let containerView = UIView()
    containerView.addSubview(vStack)
    vStack.fillToSuperview(verticalIndents: 8.0, horizontalIndents: 8.0)
    
    return containerView
  }
}
//MARK: - UIControl Actions
private extension SettingsViewController {
  @objc private func setOpaqueButton(_ view: UIControl) {
    updateButtonOpacity(true, for: view)
  }
  @objc private func setNonOpaquesButton(_ view: UIControl) {
    updateButtonOpacity(false, for: view)
  }
  private func updateButtonOpacity(_ isOpaque: Bool, for view: UIControl) {
    view.layer.opacity = isOpaque ? Constants.actionsOpacity.highlighted : Constants.actionsOpacity.base
  }
  
  @objc func selectTypeButtonAction(_ view: UIControl) {
    setNonOpaquesButton(view)
    
    guard let type = tappedItemType(for: view) else { return }
    view.springAnimation { [weak self] in
      guard let self else { return }
      
      settingAction(for: type)
    }
  }
  func settingAction(for type: SettingType) {
    switch type {
    case .sound:
      //change UserDefaults value
      let currentValue = UserDefaults.standard.isAppSoundEnabled
      UserDefaults.standard.isAppSoundEnabled = !currentValue
      //change UISwitch
      soundToggleSwitch?.setOn(!currentValue, animated: true)
    case .rateUs:
      if let windowScene = UIApplication.shared.appWindow?.windowScene {
        SKStoreReviewController.requestReview(in: windowScene)
      }
    case .shareApp:
      guard let link = type.link else { return }
      let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = self.view
      
      self.present(activityVC, animated: true)
    default:
      if let link = type.link, UIApplication.shared.canOpenURL(link) {
        UIApplication.shared.open(link)
      }
    }
  }
  
  func tappedItemType(for view: UIControl) -> SettingType? {
    SettingType.init(rawValue: view.tag)
  }
}

//MARK: - CommonNavPanelDelegate
extension SettingsViewController: CommonNavPanelDelegate {
  func backButtonAction() {
    popVC()
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static let actionsOpacity = TargetActionsOpacity()
  
  static var height: CGFloat {
    sizeProportion(for: 56.0, minSize: 44.0)
  }
  static var radius: CGFloat {
    sizeProportion(for: 16.0, minSize: 12.0)
  }
  static var hStackSpacing: CGFloat {
    sizeProportion(for: 8.0)
  }
  static let iconSize: CGSize = .init(width: 24.0, height: 24.0)
  
  static var itemFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .madaSemiBold, size: fontSize)
  }
  static let itemTextColor = AppColor.layerOne
  
  static var verFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static let verTextColor = AppColor.layerFour
  
  //toggleSwitch
  private static let toggleSwitchDefaultHeight = 30.0
  private static var toggleSwitchHeight: CGFloat {
    sizeProportion(for: toggleSwitchDefaultHeight, minSize: 24.0)
  }
  static var toggleSwitchScaleFactor: CGFloat {
    toggleSwitchHeight / toggleSwitchDefaultHeight
  }
  static var toggleSwitchLineHeight: CGFloat {
    sizeProportion(for: 10.0, minSize: 8.0)
  }
  static let toggleSwitchLineWidth: CGFloat = 2.0
  static let toggleSwitchOnTintColor = AppColor.accentOne
  static let toggleSwitchThumbTintColor = AppColor.layerOne
}

private extension SettingsViewController {
  var appVer: String {
    if let bundleVer = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return bundleVer
    } else {
      return "1.0.0"
    }
  }
}
