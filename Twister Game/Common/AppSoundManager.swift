import AVFoundation

fileprivate var player: AVAudioPlayer?

final class AppSoundManager {
  static let shared = AppSoundManager()
  private init() { }
  
  private func playSound(for type: SoundType) {
    guard UserDefaults.standard.isAppSoundEnabled else { return }
    
    let fileName = type.fileName
    let fileExtension = type.fileExtension
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return }
    
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.play()
    } catch {
#if DEBUG
      print(error.localizedDescription)
#endif
    }
  }
}
//MARK: - API
extension AppSoundManager {
  func dropoutParticipant() {
    playSound(for: .dropout)
  }
  func spinWheel() {
    playSound(for: .spinWheel)
  }
  func buttonTap() {
    playSound(for: .buttonTap)
  }
  func gameWin() {
    playSound(for: .gameWin)
  }
  
  func stopPlaying() {
    player?.stop()
  }
}


fileprivate enum SoundType {
  case dropout
  case spinWheel
  case buttonTap
  case gameWin
  
  var fileName: String {
    switch self {
    case .dropout: return "вылет-игрока-из-игры"
    case .spinWheel: return "кручение-колеса"
    case .buttonTap: return "нажатия-на-кнопки(любые кнопки, только в игре)"
    case .gameWin: return "победа-в-игре"
    }
  }
  var fileExtension: String { "mp3" }
}
