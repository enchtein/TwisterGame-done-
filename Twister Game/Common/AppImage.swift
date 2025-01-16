import UIKit

enum AppImage {
  enum OnBoarding {
    static let logo = UIImage(resource: .onBoardingOBIc)
  }
  enum CommonNavPanel {
    static let back = UIImage(resource: .backNPIc)
    static let share = UIImage(resource: .shareNPIc)
    static let exitGame = UIImage(resource: .exitGameNPIc)
    static let statistics = UIImage(resource: .statisticsNPIc)
  }
  enum Main {
    static let rules = UIImage(resource: .rulesMIc)
    static let settings = UIImage(resource: .settingsMIc)
    
    static let main = UIImage(resource: .mainMIc)
  }
  enum ParticipantField {
    static let clear = UIImage(resource: .clearPFIc)
    static let selected = UIImage(resource: .selectedPFIc)
  }
  enum NewGame {
    static let iconType = UIImage(resource: .iconTypeNGIc)
    static let arrowLeft = UIImage(resource: .arrowLeftNGIc)
    static let randomise = UIImage(resource: .randomiseNGIc)
  }
  enum Settings {
    static let sound = UIImage(resource: .soundSEIc)
    static let notifications = UIImage(resource: .notificationsSEIc)
    static let shareApp = UIImage(resource: .shareAppSEIc)
    static let contactUs = UIImage(resource: .contactUsSEIc)
    static let rateUs = UIImage(resource: .rateUsSEIc)
    static let privacyPolicy = UIImage(resource: .privacyPolicySEIc)
    static let termsOfUse = UIImage(resource: .termsOfUseSEIc)
  }
  enum Game {
    static let removeParticipant = UIImage(resource: .removeParticipantGAIc)
    static let hand = UIImage(resource: .handGAIc)
    static let leg = UIImage(resource: .legGAIc)
  }
  enum StatisticsGame {
    static let share = UIImage(resource: .shareSGIc)
  }
}
