import Foundation

extension UserDefaults {
  enum CodingKeys {
    static let isWelcomeAlreadyAppeadred = "isWelcomeAlreadyAppeadred"
    static let isDisclamerAlreadyAppeaded = "isDisclamerAlreadyAppeaded"
    
    static let isAppSoundEnabled = "isAppSoundEnabled"
    static let savedGameData = "savedGameData"
  }
  
  var isWelcomeAlreadyAppeadred: Bool {
    get { return bool(forKey: CodingKeys.isWelcomeAlreadyAppeadred) }
    set { set(newValue, forKey: CodingKeys.isWelcomeAlreadyAppeadred) }
  }
  var isDisclamerAlreadyAppeaded: Bool {
    get { return bool(forKey: CodingKeys.isDisclamerAlreadyAppeaded) }
    set { set(newValue, forKey: CodingKeys.isDisclamerAlreadyAppeaded) }
  }
  
  var isAppSoundEnabled: Bool {
    get { return bool(forKey: CodingKeys.isAppSoundEnabled) }
    set { set(newValue, forKey: CodingKeys.isAppSoundEnabled) }
  }
  
  var savedGameData: Data? {
    get { return data(forKey: CodingKeys.savedGameData) }
    set { set(newValue, forKey: CodingKeys.savedGameData) }
  }
}
