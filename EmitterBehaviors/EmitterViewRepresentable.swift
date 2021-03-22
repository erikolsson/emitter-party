//
//  EmitterViewRepresentable.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Combine

extension EmitterBehavior {

  var emitterTypeName: String {
    switch self.behaviorType {
    case .wave:
      return "wave"
    case .drag:
      return "drag"
    case .alignToMotion:
      return "alignToMotion"
    case .attractor:
      return "attractor"
    }
  }

  var asBehavior: NSObject {
    let object = createBehavior(type: emitterTypeName)
    switch self.behaviorType {
    case .wave:
      object.setValue([force.x, force.y, force.z], forKey: "force")
      object.setValue(frequency, forKey: "frequency")
    case .drag:
      object.setValue(drag, forKey: "drag")
    case .alignToMotion:
      object.setValue(rotation, forKey: "rotation")
      object.setValue(preservesDepth, forKey: "preservesDepth")
    case .attractor:
      object.setValue(attractorType.rawValue, forKey: "attractorType")
      object.setValue(NSNumber(value: Float(stiffness)), forKey: "stiffness")
      object.setValue(NSNumber(value: Float(radius)), forKey: "radius")
      object.setValue(NSNumber(value: Float(falloff)), forKey: "falloff")
      
    }

    return object
  }

  func createBehavior(type: String) -> NSObject {
    let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
    let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
    let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
    return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
  }
}

class EmitterView: UIView {

  var cancellables = Set<AnyCancellable>()
  let store: Store<AppState, AppAction>
  let viewStore: ViewStore<AppState, AppAction>

  init(store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
    super.init(frame: .zero)
    observeStore()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func observeStore() {

    viewStore.publisher.behaviors
      .receive(on: DispatchQueue.main)
      .map { $0.map(\.asBehavior) }
      .sink { [weak self] (behaviors) in
        self?.behaviors = behaviors
      }.store(in: &cancellables)

    viewStore.publisher.emitterCell
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (emitterConfiguration) in
        self?.configureEmitterCell(emitterConfiguration: emitterConfiguration)
      }.store(in: &cancellables)

    viewStore.publisher.emitter
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (val) in
        self?.configureEmitter(configuration: val)
      }.store(in: &cancellables)
  }

  let emitterLayer = CAEmitterLayer()
//  let emitterCellEmitterCell = CAEmitterCell()

  var behaviors: [NSObject] = [] {
    didSet {
      emitterLayer.setValue(behaviors, forKey: "emitterBehaviors")
    }
  }

  func configureEmitter(configuration: Emitter) {
    emitterLayer.emitterShape = CAEmitterLayerEmitterShape(rawValue: configuration.emitterShape.rawValue)
    emitterLayer.emitterSize = CGSize(width: configuration.emitterSize.x, height: configuration.emitterSize.y)
    emitterLayer.emitterPosition = configuration.emitterPosition
    emitterLayer.birthRate = Float(configuration.birthRate)

    if emitterLayer.superlayer == nil {
      layer.addSublayer(emitterLayer)
    }
  }

  var image: UIImage {
    let rect = CGRect(x: 0, y: 0, width: 13, height: 20)

    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()!
    context.setFillColor(UIColor.black.cgColor)

    context.rotate(by: .random(in: 0 ... .pi/2))
    context.move(to: .zero)
    context.addLine(to: .init(x: rect.maxX, y: 0))
    context.addLine(to: .init(x: rect.midX, y: rect.maxY))
    context.fillPath()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }


  var emitterCell: CAEmitterCell?
  func configureEmitterCell(emitterConfiguration: EmitterCell) {

    let emitterCellEmitterCell = CAEmitterCell()
    self.emitterCell = emitterCellEmitterCell

    emitterCellEmitterCell.name = "acell"
    emitterCellEmitterCell.beginTime = 0.1
    emitterCellEmitterCell.birthRate = 100
    emitterCellEmitterCell.contents = emitterConfiguration.contents
    emitterCellEmitterCell.emissionRange = emitterConfiguration.emissionRange
    emitterCellEmitterCell.lifetime = 10
    emitterCellEmitterCell.spin = 4
    emitterCellEmitterCell.spinRange = 8
    emitterCellEmitterCell.scale = 0.9
    emitterCellEmitterCell.color = UIColor(emitterConfiguration.color).cgColor

    emitterCellEmitterCell.scaleRange = emitterConfiguration.scaleRange
    emitterCellEmitterCell.scaleSpeed = emitterConfiguration.scaleSpeed
    emitterCellEmitterCell.yAcceleration = emitterConfiguration.yAcceleration

//    emitterCellEmitterCell.birthRate = 10 // Float(emitterConfiguration.birthRate)
    emitterCellEmitterCell.lifetimeRange = Float(emitterConfiguration.lifetimeRange)

    emitterCellEmitterCell.setValue(emitterConfiguration.particleType.rawValue,
                                    forKey: "particleType")
    emitterCellEmitterCell.setValue(Double(emitterConfiguration.orientationRange),
                                    forKey: "orientationRange")
    emitterCellEmitterCell.setValue(Double(emitterConfiguration.orientationLongitude),
                                    forKey: "orientationLongitude")
    emitterCellEmitterCell.setValue(Double(emitterConfiguration.orientationLatitude),
                                    forKey: "orientationLatitude")

    emitterLayer.emitterCells = [emitterCellEmitterCell]
//    emitterLayer.beginTime = CACurrentMediaTime()
  }


  override func layoutSubviews() {
    super.layoutSubviews()

    backgroundColor = .darkGray
    emitterLayer.frame = bounds
    emitterLayer.scale = 1
  }

  func createBehavior(type: String) -> NSObject {
    let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
    let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
    let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
    return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
  }

}

struct EmitterViewRepresentable: UIViewRepresentable {

  let store: Store<AppState, AppAction>

  typealias UIViewType = EmitterView
  func makeUIView(context: Context) -> EmitterView {
    return EmitterView(store: store)
  }

  func updateUIView(_ uiView: EmitterView, context: Context) {
    
  }

}
