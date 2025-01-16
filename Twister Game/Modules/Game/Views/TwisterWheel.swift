import UIKit

protocol TwisterWheelDelegate: AnyObject {
  func wheelStartRotating()
  func selectedTwisterWheelSectionDidChange(_ sectionModel: TwisterSectionModel)
  func wheelEndRotating()
}
final class TwisterWheel: UIView {
  private let sectionTypes = TwisterSectionType.allCases
  private let colors = TwisterSectionColorType.allCases
  
  private lazy var triangle = PointerView(frame: .init(origin: .zero, size: CGSize.init(width: 48.0, height: 36.0)))
  private lazy var spinner = TwisterSpinner(sectionModels: getSectionModels(), delegate: self)
  private var currentRotationAngle: CGFloat = 0
  
  private var animationTimer: Timer?
  private var animationTimerDuration: TimeInterval = .zero
  
  private weak var delegate: TwisterWheelDelegate?
  init(delegate: TwisterWheelDelegate?) {
    self.delegate = delegate
    super.init(frame: .zero)
    
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(spinner)
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.topAnchor.constraint(equalTo: topAnchor, constant: 14.0).isActive = true
    spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor).isActive = true
    spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    addSubview(triangle)
    triangle.translatesAutoresizingMaskIntoConstraints = false
    triangle.topAnchor.constraint(equalTo: topAnchor).isActive = true
    triangle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    triangle.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
    triangle.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
  }
  
  private func getSectionModels() -> [TwisterSectionModel] {
    var res = [TwisterSectionModel]()
    
    for type in sectionTypes {
      let coloredType = colors.map {
        TwisterSectionModel.init(type: type, colorType: $0)
      }
      res += coloredType
    }
    
    return res
  }
}
//MARK: - API
extension TwisterWheel {
  func rotateWheel() {
    let beginAngleValue = currentRotationAngle
    
    //generate random values
    let randomRotations = CGFloat(arc4random_uniform(5) + 5) //From 5 to 10 full rotations
    let randomAngle = CGFloat(arc4random_uniform(360)).radians //Random angle for stop
    
    let totalRotation = (2 * .pi * randomRotations) + randomAngle  //Positive value for rotation according clockwise
    let endAngleValue = beginAngleValue + totalRotation
    
    let model = WheelRotationModel(keyType: .rotateWheel, beginAngle: currentRotationAngle, endAngle: endAngleValue)
    rotateWheel(according: model)
    
    delegate?.wheelStartRotating()
  }
  
  func restartWheel() {
    //setup end rotation value
    currentRotationAngle = spinner.startSpinerAngle
    //setting new transform value
    spinner.transform = CGAffineTransform(rotationAngle: spinner.startSpinerAngle)
  }
}
//MARK: - TwisterSpinnerProtocol
extension TwisterWheel: TwisterSpinnerProtocol {
  func startRotationAngleDidChange(to value: CGFloat) { //call once on init
    currentRotationAngle = value
  }
}
//MARK: - CAAnimationDelegate
extension TwisterWheel: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    invalidateSpinTimer()
    
    let animationType: TwisterSpinnerAnimation? = TwisterSpinnerAnimation.allCases.compactMap {
      guard let _ = anim.value(forKey: $0.key) else { return nil }
      return $0
    }.first
    
    guard let animationType else { return }
    switch animationType {
    case .rotateWheel:
      AppSoundManager.shared.stopPlaying()
      
      let selectedPieceView = updateSelectedTwisterWheelSection()
      guard let selectedPieceView else { return }
      
      centered(selectedPieceView)
    case .centeredSelectedPiece:
      delegate?.wheelEndRotating()
    }
  }
  
  @discardableResult
  private func updateSelectedTwisterWheelSection() -> SectionComponents? {
    let currentSelectedView = spinner.pieceViews.min { pieceView_0, pieceView_1 in
      let convertedOrigin_0 = spinner.convert(pieceView_0.center, to: self)
      let convertedOrigin_1 = spinner.convert(pieceView_1.center, to: self)
      
      return convertedOrigin_0.y < convertedOrigin_1.y
    }
    
    guard let selectedPieceView = currentSelectedView else { return nil }
    delegate?.selectedTwisterWheelSectionDidChange(selectedPieceView.sectionModel)
    
    return selectedPieceView
  }
}
//MARK: - Helpers
private extension TwisterWheel {
  func centered(_ selectedPieceView: SectionComponents) {
    let selectedPieceViewCenter = spinner.convert(selectedPieceView.center, to: self)
    
    let currentPieceAngle = selectedPieceViewCenter.angle(to: CGPoint(x: self.frame.midX, y: self.frame.maxY))
    let verticalDegrees = (.pi / 2).degrees
    
    let additionalAngle = verticalDegrees - currentPieceAngle
    
    rotateWheel(to: additionalAngle)
  }
  func rotateWheel(to degrees: CGFloat) {
    let beginAngleValue = currentRotationAngle
    let endAngleValue = beginAngleValue + degrees.radians
    
    let model = WheelRotationModel(keyType: .centeredSelectedPiece, beginAngle: currentRotationAngle, endAngle: endAngleValue)
    
    rotateWheel(according: model)
  }
  
  func rotateWheel(according model: WheelRotationModel) {
    //create rotation animation
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = model.beginAngle //begin animation
    animation.toValue = model.endAngle //end animation
    animation.duration = model.keyType.animationDuration //animtaion duration
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.delegate = self
    animation.setValue(model.keyType.key, forKey: model.keyType.key)
    //setup end rotation value
    currentRotationAngle = model.endAngle
    
    //apply animation to layer
    spinner.layer.add(animation, forKey: "rotationAnimation")
    
    //setting new transform value
    spinner.transform = CGAffineTransform(rotationAngle: model.endAngle)
    
    //add vibration while rotate wheel
    scheduleSpinTimer(according: model)
    //add sound while rotate wheel
    playSound(according: model)
  }
  
  func playSound(according model: WheelRotationModel) {
    guard model.keyType == .rotateWheel else { return }
    AppSoundManager.shared.spinWheel()
  }
  
  func scheduleSpinTimer(according model: WheelRotationModel) {
    invalidateSpinTimer()
    
    let timeInterval = model.keyType.spinTimerActionInterval
    animationTimerDuration = model.keyType.animationDuration - (timeInterval * 3) //vibration should end before end rotate wheel animation
    
    animationTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(spinTimerAction), userInfo: ["model": model], repeats: true)
  }
  @objc func spinTimerAction(timer: Timer) {
    let userInfo = timer.userInfo as? [String: Any] ?? [:]
    guard let model = userInfo["model"] as? WheelRotationModel else { return }
    
    switch model.keyType {
    case .rotateWheel:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)
    case .centeredSelectedPiece:
      let generator = UISelectionFeedbackGenerator()
      generator.selectionChanged()
    }
    
    animationTimerDuration -= model.keyType.spinTimerActionInterval
    
    if animationTimerDuration <= 0 {
      invalidateSpinTimer()
    }
  }
  func invalidateSpinTimer() {
    animationTimer?.invalidate()
    animationTimer = nil
    animationTimerDuration = .zero
  }
}
//MARK: - PointerView (Triangle)
fileprivate final class PointerView: UIView {
  private var pointerLayer: CAShapeLayer!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
    self.transform = CGAffineTransform(rotationAngle: .pi)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    pointerLayer.removeFromSuperlayer()
    setupUI()
  }
  
  private func setupUI() {
    let triangle = CAShapeLayer()
    triangle.fillColor = AppColor.layerSix.cgColor
    let radius = bounds.height / 6
    triangle.path = createRoundedTriangle(width: bounds.width, height: bounds.height, radius: radius)
    
    layer.addSublayer(triangle)
    pointerLayer = triangle
  }
  private func createRoundedTriangle(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPath {
    // The triangle's three corners.
    let bottomLeft = CGPoint(x: 0, y: height)
    let bottomRight = CGPoint(x: width, y: height)
    let topMiddle = CGPoint(x: bounds.midX, y: 0)
    
    // We'll start drawing from the bottom middle of the triangle,
    // the midpoint between the two lower corners.
    let bottomMiddle = CGPoint(x: bounds.midX, y: height)
    
    // Draw three arcs to trace the triangle.
    let path = CGMutablePath()
    path.move(to: bottomMiddle)
    path.addArc(tangent1End: bottomRight, tangent2End: topMiddle, radius: radius)
    path.addArc(tangent1End: topMiddle, tangent2End: bottomLeft, radius: radius)
    path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: radius)
    
    return path
  }
}

//MARK: - TwisterSpinner
fileprivate protocol TwisterSpinnerProtocol: AnyObject {
  func startRotationAngleDidChange(to value: CGFloat)
}
fileprivate final class TwisterSpinner: UIView {
  private(set) var startSpinerAngle: CGFloat = 0
  
  private var pieceLayers: [CAShapeLayer] = []
  private(set) var pieceViews: [SectionComponents] = []
  private var shadowViews: [UIView] = []
  private var circleWithBorder: UIView?
  
  private weak var delegate: TwisterSpinnerProtocol?
  
  private let sectionModels: [TwisterSectionModel]
  init(sectionModels: [TwisterSectionModel], delegate: TwisterSpinnerProtocol?) {
    self.sectionModels = sectionModels
    self.delegate = delegate
    
    super.init(frame: .zero)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    //clear layer
    pieceLayers.forEach { $0.removeFromSuperlayer() }
    //clear view
    pieceViews.forEach { $0.removeFromSuperview() }
    shadowViews.forEach { $0.removeFromSuperview() }
    circleWithBorder?.removeFromSuperview()
    
    drawCircleWithSections()
  }
  
  private func drawCircleWithSections() {
    pieceLayers.removeAll() //clearing stored values
    pieceViews.removeAll() //clearing stored values
    
    
    let numberOfSections = sectionModels.count //16
    
    let circleRadius = min(self.bounds.width, self.bounds.height) / 2
    let angleStep = (2 * CGFloat.pi) / CGFloat(numberOfSections)
    let center = CGPoint(x: circleRadius, y: circleRadius)
    
    for (i, sectionModel) in sectionModels.enumerated() {
      //1) add section layer
      //calculate angle for each section
      let angle = CGFloat(i) * angleStep
      let startAngle = angle - CGFloat.pi / 2 //begin from top center
      let endAngle = startAngle + angleStep
      let middleAngle = startAngle + (angleStep / 2)
      
      //create path for section
      let path = UIBezierPath()
      path.move(to: center)
      path.addArc(withCenter: center, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      //closing path
      path.close()
      
      //create layer for section
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path.cgPath
      shapeLayer.fillColor = sectionModel.colorType.color.cgColor //fill by color
      
      //add layer to view
      self.layer.addSublayer(shapeLayer)
      pieceLayers.append(shapeLayer)
      
      
      //2) add SectionComponent
      let startPoint = pointFromAngle(angle: startAngle, radius: circleRadius, center: center)
      let endPoint = pointFromAngle(angle: endAngle, radius: circleRadius, center: center)
      
      let distance = distanceBetweenPoints(point1: startPoint, point2: endPoint)
      
      let sectionView = SectionComponents(sectionModel: sectionModel, frame: .init(origin: .zero, size: CGSize(width: circleRadius, height: distance)))
      
      //calculate section center coordinates
      let xPosition = (circleRadius + (cos(middleAngle) * (circleRadius / 2)))
      let yPosition = (circleRadius + (sin(middleAngle) * (circleRadius / 2)))
      
      sectionView.center = CGPoint(x: xPosition, y: yPosition)
      
      //add section rotation, that it was looking to center
      sectionView.transform = CGAffineTransform(rotationAngle: middleAngle)
      
      //add section to container (to superview)
      addSubview(sectionView)
      pieceViews.append(sectionView)
      
      
      //3) add shadow
      let lineView = UIView(frame: .init(origin: .zero, size: CGSize(width: circleRadius, height: 1)))
      lineView.backgroundColor = .clear
      
      //calculate lineView center coordinates
      let xPositionLine = (circleRadius + (cos(startAngle) * (circleRadius / 2)))
      let yPositionLine = (circleRadius + (sin(startAngle) * (circleRadius / 2)))
      
      lineView.center = CGPoint(x: xPositionLine, y: yPositionLine)
      
      //add lineView rotation, that it was looking to center
      lineView.transform = CGAffineTransform(rotationAngle: startAngle)
      
      //setup shadow
      lineView.layer.masksToBounds = false
      lineView.layer.shadowColor = AppColor.innerShadow.cgColor
      lineView.layer.shadowOpacity = 1.0
      lineView.layer.shadowOffset = CGSize(width: 0, height: 0)
      lineView.layer.shadowRadius = 3.0

      lineView.layer.shadowPath = UIBezierPath(rect: lineView.bounds).cgPath
      lineView.layer.shouldRasterize = true
      
      addSubview(lineView)
      shadowViews.append(lineView)
    }
    
    transform = CGAffineTransform(rotationAngle: -(angleStep / 2))
    delegate?.startRotationAngleDidChange(to: -(angleStep / 2))
    startSpinerAngle = -(angleStep / 2)
    
    //4) add border
    borderedView()
  }
  
  //func for getting CGPoint according Angle and Radius
  private func pointFromAngle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
    let x = center.x + radius * cos(angle)
    let y = center.y + radius * sin(angle)
    return CGPoint(x: x, y: y)
  }
  //func for getting distance between two CGPoint's
  private func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let deltaX = point2.x - point1.x
    let deltaY = point2.y - point1.y
    return sqrt(deltaX * deltaX + deltaY * deltaY)
  }
  
  private func borderedView() {
    let circleRadius = min(bounds.width, bounds.height) / 2
    let center = CGPoint(x: circleRadius, y: circleRadius)
    
    let view = UIView(frame: bounds)
    addSubview(view)
    view.center = center
    
    view.layer.borderColor = AppColor.layerTwo.cgColor
    view.layer.borderWidth = 3.0
    view.setRounded()
    view.setInnerShadow(with: circleRadius, and: AppColor.innerShadow, shadowRadius: 8.0)
    
    circleWithBorder = view
  }
}

//MARK: - SectionComponents
fileprivate final class SectionComponents: UIView {
  let sectionModel: TwisterSectionModel
  private var modelType: TwisterSectionType { sectionModel.type }
  
  init(sectionModel: TwisterSectionModel, frame: CGRect) {
    self.sectionModel = sectionModel
    
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.spacing = SectionComponentsConstants.indent
    
    addSubview(hStack)
    hStack.translatesAutoresizingMaskIntoConstraints = false
    hStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: SectionComponentsConstants.heightMultiplier).isActive = true
    hStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: SectionComponentsConstants.widthMultiplier).isActive = true
    hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SectionComponentsConstants.indent).isActive = true
    hStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    //1
    let label = UILabel()
    label.text = modelType.title
    label.textAlignment = .left
    label.font = SectionComponentsConstants.font
    label.textColor = SectionComponentsConstants.textColor
    label.transform = CGAffineTransform(rotationAngle: .pi)
    label.setShadow(with: .zero, and: AppColor.shadowOne)
    
    hStack.addArrangedSubview(label)
    
    //2
    let imageView = UIImageView()
    imageView.image = modelType.image
    imageView.transform = CGAffineTransform(rotationAngle: .pi)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    
    hStack.addArrangedSubview(imageView)
  }
}

//MARK: - Constants
fileprivate struct SectionComponentsConstants: CommonSettings {
  static let textColor = AppColor.layerOne
  static var font: UIFont {
    let fontSize = sizeProportion(for: 20.0)
    return AppFont.font(type: .madaBold, size: fontSize)
  }
  static var indent: CGFloat {
    sizeProportion(for: 16.0)
  }
  
  static let heightMultiplier: CGFloat = 0.56
  static let widthMultiplier: CGFloat = 0.62
}
//MARK: - WheelRotationModel
fileprivate struct WheelRotationModel {
  let keyType: TwisterSpinnerAnimation
  let beginAngle: CGFloat
  let endAngle: CGFloat
}
//MARK: - TwisterSpinnerAnimation
fileprivate enum TwisterSpinnerAnimation: String, CaseIterable {
  case rotateWheel
  case centeredSelectedPiece
  
  var key: String {
    switch self {
    case .rotateWheel: return "rotateWheel"
    case .centeredSelectedPiece: return "centeredSelectedPiece"
    }
  }
  
  var animationDuration: TimeInterval {
    switch self {
    case .rotateWheel: return 5.0
    case .centeredSelectedPiece: return 1.0
    }
  }
  
  var spinTimerActionInterval: TimeInterval {
    switch self {
    case .rotateWheel: return 0.45
    case .centeredSelectedPiece: return 0.25
    }
  }
}
//MARK: - extension CGFloat
fileprivate extension CGFloat {
  var degrees: CGFloat {
    return self * CGFloat(180) / .pi
  }
  var radians: CGFloat {
    return self * .pi / 180
  }
}
//MARK: - extension CGPoint
fileprivate extension CGPoint {
  func angle(to comparisonPoint: CGPoint) -> CGFloat {
    let originX = comparisonPoint.x - x
    let originY = comparisonPoint.y - y
    let bearingRadians = atan2f(Float(originY), Float(originX))
    var bearingDegrees = CGFloat(bearingRadians).degrees
    
    while bearingDegrees < 0 {
      bearingDegrees += 360
    }
    
    return bearingDegrees
  }
}
