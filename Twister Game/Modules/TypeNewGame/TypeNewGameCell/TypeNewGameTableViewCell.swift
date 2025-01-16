import UIKit

protocol TypeNewGameTableViewCellDelegate: AnyObject {
  func didSelect(cell: TypeNewGameTableViewCell)
}
final class TypeNewGameTableViewCell: UITableViewCell {
  @IBOutlet weak var contentContainer: UIView!
  @IBOutlet weak var contentContainerTop: NSLayoutConstraint!
  @IBOutlet weak var contentContainerBottom: NSLayoutConstraint!
  
  @IBOutlet weak var contentVStack: UIStackView!
  @IBOutlet weak var contentVStackTop: NSLayoutConstraint!
  @IBOutlet weak var contentVStackLeading: NSLayoutConstraint!
  @IBOutlet weak var contentVStackTrailing: NSLayoutConstraint!
  @IBOutlet weak var contentVStackBottom: NSLayoutConstraint!
  @IBOutlet weak var gameTypeTitle: UILabel!
  @IBOutlet weak var gameTypeDescription: UILabel!
  
  private weak var delegate: TypeNewGameTableViewCellDelegate?
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    guard selected else { return }
    contentContainer.springAnimation { [weak self] in
      guard let self else { return }
      delegate?.didSelect(cell: self)
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.setNeedsLayout()
    contentView.layoutIfNeeded()
    contentContainer.setInnerShadow(with: Constants.contentContainerRadius, and: AppColor.innerShadow)
  }
  
  func setupUI(with item: GameType, isSelected: Bool, isFirst: Bool, isLast: Bool, delegate: TypeNewGameTableViewCellDelegate?) {
    self.delegate = delegate
    
    gameTypeTitle.text = item.title
    gameTypeDescription.text = item.description
    
    setupColorTheme()
    setupFontThemeTheme()
    setupConstraints(isFirst: isFirst, isLast: isLast)
    
    updateUIAccording(isSelected: isSelected)
  }
  
  func updateUIAccording(isSelected: Bool) {
    UIView.animate(withDuration: contentContainer.animationDuration) {
      self.contentContainer.layer.borderColor = isSelected ? AppColor.layerOne.cgColor : UIColor.clear.cgColor
      self.contentContainer.layer.borderWidth = 2.0
    }
    
    UIView.transition(with: gameTypeTitle, duration: contentContainer.animationDuration, options: .transitionCrossDissolve) {
      self.gameTypeTitle.textColor = isSelected ? AppColor.accentOne : Constants.titleColor
    }
    UIView.transition(with: gameTypeDescription, duration: contentContainer.animationDuration, options: .transitionCrossDissolve) {
      self.gameTypeDescription.textColor = isSelected ? AppColor.layerOne : Constants.descriptionColor
    }
  }
}
//MARK: - UI setting
private extension TypeNewGameTableViewCell {
  func setupColorTheme() {
    gameTypeTitle.textColor = Constants.titleColor
    gameTypeDescription.textColor = Constants.descriptionColor
    
    contentContainer.backgroundColor = AppColor.layerSix
    
    contentView.backgroundColor = .clear
    backgroundColor = .clear
  }
  func setupFontThemeTheme() {
    gameTypeTitle.font = Constants.titleFont
    gameTypeDescription.font = Constants.descriptionFont
  }
  func setupConstraints(isFirst: Bool, isLast: Bool) {
    contentContainerTop.constant = isFirst ? .zero : 8.0
    contentContainerBottom.constant = isLast ? .zero : 8.0
    
    [contentVStackTop, contentVStackLeading, contentVStackTrailing, contentVStackBottom].forEach {
      $0?.constant = Constants.baseSideIndent
    }
  }
}
//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var titleFont: UIFont {
    let fontSize = sizeProportion(for: 24.0, minSize: 20.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static let titleColor = AppColor.layerOne
  
  static var descriptionFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .madaRegular, size: fontSize)
  }
  static let descriptionColor = AppColor.layerTwo
  
  static var contentContainerRadius: CGFloat {
    Self.containerTopRadius / 2
  }
}
