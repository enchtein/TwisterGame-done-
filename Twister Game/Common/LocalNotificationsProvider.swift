import UserNotifications
import UIKit

final class LocalNotificationsProvider {
  static let shared = LocalNotificationsProvider()
  private(set) var isAuthorized = false
  
  private init() {}
  
  func requestNotificationPermission(successCompletion: (() -> Void)? = nil) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] didAllow, error in
      guard let self else { return }
      
      if didAllow {
        successCompletion?()
      } else {
#if DEBUG
        print("Permission for push notifications denied.")
#endif
      }
      
      updateAuthorizationStatus()
    }
  }
}
//MARK: - Helpers
private extension LocalNotificationsProvider {
  private func updateAuthorizationStatus() {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      self?.isAuthorized = settings.authorizationStatus == .authorized
    }
  }
  
  private func removeAllNotifications() {
    updateBadgeCountToZero()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
//MARK: - API
extension LocalNotificationsProvider {
  func updateBadgeCountToZero() {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0)
    } else {
      // Fallback on earlier versions
      UIApplication.shared.applicationIconBadgeNumber = 0
    }
  }
}
