import UIKit

class BaseViewController: UIViewController {
  private(set) var isAppeared = false
  private var kbRect: CGRect = .zero
  
  private var gradientLayer: CAGradientLayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBaseUISettings()
    setupUI()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isAppeared = true
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    isAppeared = false
  }
  
  private final func setupBaseUISettings() {
    //setup gradient
    let gLayer = view.createGradientLayer(withColours: AppColor.backgroundGradientTwo, AppColor.backgroundGradientOne)
    gradientLayer = gLayer
    view.layer.insertSublayer(gLayer, at: 0)
  }
  
  private final func setupUI() {
    addUIComponents()
    setupColorTheme()
    setupFontTheme()
    setupLocalizeTitles()
    setupIcons()
    setupConstraintsConstants()
    additionalUISettings()
  }
  
  func addUIComponents() {}
  
  func setupColorTheme() {}
  func setupFontTheme() {}
  func setupLocalizeTitles() {}
  func setupIcons() {}
  
  func setupConstraintsConstants() {}
  func additionalUISettings() {}
  
  final func popVC() {
    navigationController?.popViewController(animated: true)
  }
  final func popToRootVC() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func kbFrameChange(to kbRect: CGRect) {}
  
  final func removeGradientLayer() {
    gradientLayer?.removeFromSuperlayer()
  }
  final func reCreateGradientLayer() {
    removeGradientLayer()
    setupBaseUISettings()
  }
}

//MARK: - keyboard show/hide actions
extension BaseViewController {
  @objc private final func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      kbRect = keyboardFrame.cgRectValue
    }
    kbFrameChange(to: kbRect)
  }
  @objc private final func keyboardWillHide(notification: NSNotification) {
    kbRect = .zero
    kbFrameChange(to: kbRect)
  }
}
//MARK: - extension UIView (Gradient)
extension UIView {
  final func createGradientLayer(withColours: UIColor...) -> CAGradientLayer {
    var cgColours = [CGColor]()
    
    for colour in withColours {
      cgColours.append(colour.cgColor)
    }
    let grad = CAGradientLayer()
    grad.frame = self.bounds
    grad.colors = cgColours
    
    return grad
  }
}
