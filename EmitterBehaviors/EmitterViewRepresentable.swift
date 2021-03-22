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

    viewStore.publisher.emitter
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (emitterConfiguration) in
        self?.configureEmitter(emitterConfiguration: emitterConfiguration)
      }.store(in: &cancellables)
  }

  let emitterLayer = CAEmitterLayer()
  let emitterCellEmitterCell = CAEmitterCell()

  var behaviors: [NSObject] = [] {
    didSet {
      emitterLayer.emitterCells = [emitterCellEmitterCell]
      emitterLayer.setValue(behaviors, forKey: "emitterBehaviors")
    }
  }

  func configureEmitter(emitterConfiguration: Emitter) {
    emitterCellEmitterCell.contents = emitterConfiguration.contents
    emitterCellEmitterCell.color = UIColor(emitterConfiguration.color).cgColor
    emitterLayer.scale = Float(emitterConfiguration.scale)
    emitterLayer.lifetime = Float(emitterConfiguration.lifetime)

    emitterCellEmitterCell.scaleRange = emitterConfiguration.scaleRange
    emitterCellEmitterCell.scaleSpeed = emitterConfiguration.scaleSpeed
    emitterCellEmitterCell.spin = emitterConfiguration.spin
    emitterCellEmitterCell.spinRange = emitterConfiguration.spinRange
    emitterCellEmitterCell.velocity = emitterConfiguration.velocity
    emitterCellEmitterCell.velocityRange = emitterConfiguration.velocityRange
    emitterCellEmitterCell.xAcceleration = emitterConfiguration.xAcceleration
    emitterCellEmitterCell.zAcceleration = emitterConfiguration.zAcceleration
    emitterCellEmitterCell.emissionRange = emitterConfiguration.emissionRange
    emitterCellEmitterCell.birthRate = Float(emitterConfiguration.birthRate)

    emitterCellEmitterCell.lifetimeRange = Float(emitterConfiguration.lifetimeRange)


    emitterLayer.emitterCells = [emitterCellEmitterCell]
    emitterLayer.setValue(behaviors, forKey: "emitterBehaviors")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    guard emitterLayer.superlayer == nil else { return }
    layer.addSublayer(emitterLayer)
    emitterLayer.birthRate = 1
    backgroundColor = .systemYellow
    emitterLayer.position = center

    emitterCellEmitterCell.name = "Emitter Cell"
//    emitterCellEmitterCell.contents = UIImage(named: "default-emitter")?.cgImage
//    emitterCellEmitterCell.color = UIColor.red.cgColor
//    emitterCellEmitterCell.scale = 1
//    emitterCellEmitterCell.scaleRange = 0.2
//    emitterCellEmitterCell.scaleSpeed = 0.03
//    emitterCellEmitterCell.spin = 0.3
//    emitterCellEmitterCell.spinRange = 0.1
//    emitterCellEmitterCell.velocity = 10
//    emitterCellEmitterCell.velocityRange = 8
//    emitterCellEmitterCell.xAcceleration = 0.2
//    emitterCellEmitterCell.zAcceleration = 50
//    emitterCellEmitterCell.emissionRange = 6.28
//    emitterCellEmitterCell.birthRate = 10
//    emitterCellEmitterCell.lifetime = 5
//    emitterCellEmitterCell.lifetimeRange = 4
//    emitterCellEmitterCell.redRange = 0.3
//    emitterCellEmitterCell.redSpeed = 0.5
//    emitterCellEmitterCell.greenRange = 0.3
//    emitterCellEmitterCell.greenSpeed = 0.5
//    emitterCellEmitterCell.blueRange = 0.3
//    emitterCellEmitterCell.blueSpeed = 0.5
//    emitterCellEmitterCell.alphaRange = 0.9
//    emitterCellEmitterCell.alphaSpeed = 0.5
    emitterCellEmitterCell.fillMode = .forwards

    emitterLayer.emitterCells = [emitterCellEmitterCell]

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
