import UIKit

enum SettingType: Int, CaseIterable {
  case sound = 0
  case notifications
  
  case shareApp
  case contactUs
  case rateUs
  
  case privacyPolicy
  case termsOfUse
  
  static var firstSection: [SettingType] {
    [.sound, .notifications]
  }
  static var secondSection: [SettingType] {
    [.shareApp, .contactUs, .rateUs]
  }
  static var thirdSection: [SettingType] {
    [.privacyPolicy, .termsOfUse]
  }
  
  var title: String {
    switch self {
    case .sound: SettingsTitles.sound.localized
    case .notifications: SettingsTitles.notifications.localized
    case .shareApp: SettingsTitles.shareApp.localized
    case .contactUs: SettingsTitles.contactUs.localized
    case .rateUs: SettingsTitles.rateUs.localized
    case .privacyPolicy: SettingsTitles.privacyPolicy.localized
    case .termsOfUse: SettingsTitles.termsOfUse.localized
    }
  }
  var image: UIImage {
    switch self {
    case .sound: AppImage.Settings.sound
    case .notifications: AppImage.Settings.notifications
    case .shareApp: AppImage.Settings.shareApp
    case .contactUs: AppImage.Settings.contactUs
    case .rateUs: AppImage.Settings.rateUs
    case .privacyPolicy: AppImage.Settings.privacyPolicy
    case .termsOfUse: AppImage.Settings.termsOfUse
    }
  }
  
  var link: URL? {
    switch self {
    case .sound: nil
    case .notifications:
      if #available(iOS 16.0, *) {
        URL(string: UIApplication.openNotificationSettingsURLString)
      } else {
        URL(string: UIApplication.openSettingsURLString)
      }
    case .shareApp:
      URL(string: "https://apps.apple.com/app/0000000000")
    case .contactUs:
      URL(string: "https://www.google.com/")
    case .rateUs: nil
    case .privacyPolicy:
      URL(string: "https://www.google.com/")
    case .termsOfUse:
      URL(string: "https://www.google.com/")
    }
  }
}
