import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else {
      assertionFailure("Please, choose launch storyboard")
      return false
    }
    
    AppCoordinator.shared.start(with: window) {
      LocalNotificationsProvider.shared.requestNotificationPermission()
    }
    
    return true
  }
}

