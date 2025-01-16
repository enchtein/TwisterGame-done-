import UIKit

final class AppCoordinator: NSObject {
  static let shared = AppCoordinator()
  var currentNavigator: UINavigationController?
  
  private override init() { }
  
  func start(with window: UIWindow, completion: @escaping (() -> Void) = {}) {
    completion()
    
    let splashScreenViewController = self.instantiate(.splashScreen)
    currentNavigator = UINavigationController(rootViewController: splashScreenViewController)
    
    currentNavigator?.setNavigationBarHidden(true, animated: true)
    window.rootViewController = currentNavigator
    window.makeKeyAndVisible()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      if !UserDefaults.standard.isWelcomeAlreadyAppeadred {
        self.showWelcome()
      } else {
        self.activateRoot()
      }
    }
  }
  
  func activateRoot() {
    guard let currentNavigator else { fatalError("currentNavigator - is not initilized") }
    prepair(currentNavigator)
    currentNavigator.setViewControllers([instantiate(.main)], animated: true)
  }
  func showWelcome(isPrepairNeeded: Bool = true) {
    guard let currentNavigator else { fatalError("currentNavigator - is not initilized") }
    
    if isPrepairNeeded {
      prepair(currentNavigator)
    }
    
    currentNavigator.setViewControllers([instantiate(.onBoarding)], animated: true)
  }
  
  func push(_ controller: AppViewController, animated: Bool = true) {
    let vc = instantiate(controller)
    currentNavigator?.pushViewController(vc, animated: animated)
  }
  func present(_ controller: AppViewController, animated: Bool) {
    let presentingVC = UIApplication.topViewController()
    let vc = instantiate(controller)
    
    presentingVC?.present(vc, animated: animated, completion: nil)
  }
  
  func child(before vc: UIViewController) -> UIViewController? {
    let viewControllers = currentNavigator?.viewControllers ?? []
    
    guard let currentVCIndex = viewControllers.firstIndex(of: vc) else { return nil }
    let prevIndex = viewControllers.index(before: currentVCIndex)
    
    guard viewControllers.indices.contains(prevIndex) else { return nil }
    return viewControllers[prevIndex]
  }
}

//MARK: - Helpers
extension AppCoordinator {
  private func instantiate(_ controller: AppViewController) -> UIViewController {
    switch controller {
    case .splashScreen:
      return SplashScreenViewController.createFromStoryboard()
    case .onBoarding:
      return OnBoardingViewController.createFromStoryboard()
    case .main:
      return MainViewController.createFromStoryboard()
    case .newGame(let countOfParticipants):
      let vc = NewGameViewController.createFromStoryboard()
      vc.countOfParticipants = countOfParticipants
      
      return vc
    case .newGameWith(let model):
      let vc = NewGameViewController.createFromStoryboard()
      vc.countOfParticipants = model.countOfParticipants
      vc.model = model
      
      return vc
    case .typeNewGame(let model):
      let vc = TypeNewGameViewController.createFromStoryboard()
      vc.model = model
      
      return vc
    case.rules:
      return RulesViewController.createFromStoryboard()
    case .settings:
      return SettingsViewController.createFromStoryboard()
    case .game(let newGameModel):
      let vc = GameViewController.createFromStoryboard()
      vc.newGameModel = newGameModel
      
      return vc
    default:
      let vc = UIViewController()
      vc.view.backgroundColor = .green
      return vc
    }
  }
  private func prepair(_ navVC: UINavigationController) {
    navVC.popToRootViewController(animated: true)
    navVC.setNavigationBarHidden(true, animated: true)
  }
}
