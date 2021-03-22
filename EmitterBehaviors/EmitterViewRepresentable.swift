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
      object.setValue(position, forKey: "position")
      
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

//    viewStore.publisher.emitterCell
//      .receive(on: DispatchQueue.main)
//      .sink { [weak self] (emitterConfiguration) in
//        self?.configureEmitterCell(emitterConfiguration: emitterConfiguration)
//      }.store(in: &cancellables)

    viewStore.publisher.emitter
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (val) in
        self?.configureEmitter(configuration: val)
      }.store(in: &cancellables)

    viewStore.publisher.emitter
      .receive(on: DispatchQueue.main)
      .sink { [weak self] emitter in
        self?.configureEmitter(configuration: emitter)
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
    emitterLayer.emitterSize = CGSize(width: configuration.emitterSize.x,
                                      height: configuration.emitterSize.y)
    emitterLayer.emitterPosition = configuration.emitterPosition
    emitterLayer.birthRate = Float(configuration.birthRate)

    var emitterCells: [CAEmitterCell] = []
    for emitterConfiguration in configuration.emitterCells {
      let emitterCell = CAEmitterCell()

      emitterCell.name = "\(emitterConfiguration.id)"
      emitterCell.beginTime = 0.1
      emitterCell.contents = emitterConfiguration.contents.image?.cgImage
      emitterCell.emissionRange = emitterConfiguration.emissionRange
      emitterCell.spin = emitterConfiguration.spin
      emitterCell.spinRange = emitterConfiguration.spinRange

      emitterCell.scale = emitterConfiguration.scale
      emitterCell.color = UIColor(emitterConfiguration.color.opacity(Double(emitterConfiguration.alpha))).cgColor

      emitterCell.velocity = emitterConfiguration.velocity
      emitterCell.velocityRange = emitterConfiguration.velocityRange
      emitterCell.birthRate = Float(emitterConfiguration.birthRate)
      emitterCell.scaleRange = emitterConfiguration.scaleRange
      emitterCell.scaleSpeed = emitterConfiguration.scaleSpeed
      emitterCell.xAcceleration = emitterConfiguration.acceleration.x
      emitterCell.yAcceleration = emitterConfiguration.acceleration.y
      emitterCell.zAcceleration = emitterConfiguration.acceleration.z
      emitterCell.velocity = emitterConfiguration.velocity
      emitterCell.velocityRange = emitterConfiguration.velocityRange
      emitterCell.alphaSpeed = Float(emitterConfiguration.alphaSpeed)
      emitterCell.alphaRange = Float(emitterConfiguration.alphaRange)
      emitterCell.redRange = Float(emitterConfiguration.redRange)
      emitterCell.redSpeed = Float(emitterConfiguration.redSpeed)
      emitterCell.greenRange = Float(emitterConfiguration.greenRange)
      emitterCell.greenSpeed = Float(emitterConfiguration.greenSpeed)
      emitterCell.blueRange = Float(emitterConfiguration.blueRange)
      emitterCell.blueSpeed = Float(emitterConfiguration.blueSpeed)
      emitterCell.lifetime = Float(emitterConfiguration.lifetime)
      emitterCell.lifetimeRange = Float(emitterConfiguration.lifetimeRange)

      emitterCell.setValue(emitterConfiguration.particleType.rawValue,
                                      forKey: "particleType")
      emitterCell.setValue(Double(emitterConfiguration.orientationRange),
                                      forKey: "orientationRange")
      emitterCell.setValue(Double(emitterConfiguration.orientationLongitude),
                                      forKey: "orientationLongitude")
      emitterCell.setValue(Double(emitterConfiguration.orientationLatitude),
                                      forKey: "orientationLatitude")

      emitterCells.append(emitterCell)
    }

    if emitterLayer.superlayer == nil {
      layer.addSublayer(emitterLayer)
    }

    emitterLayer.emitterCells = emitterCells
  }


  func configureEmitterCell(emitterConfiguration: EmitterCell) {

    let emitterCell = CAEmitterCell()

    emitterCell.name = "acell"
    emitterCell.beginTime = 0.1
    emitterCell.contents = emitterConfiguration.contents.image?.cgImage
    emitterCell.emissionRange = emitterConfiguration.emissionRange
    emitterCell.spin = emitterConfiguration.spin
    emitterCell.spinRange = emitterConfiguration.spinRange

    emitterCell.scale = emitterConfiguration.scale
    emitterCell.color = UIColor(emitterConfiguration.color.opacity(Double(emitterConfiguration.alpha))).cgColor

    emitterCell.velocity = emitterConfiguration.velocity
    emitterCell.velocityRange = emitterConfiguration.velocityRange
    emitterCell.birthRate = Float(emitterConfiguration.birthRate)
    emitterCell.scaleRange = emitterConfiguration.scaleRange
    emitterCell.scaleSpeed = emitterConfiguration.scaleSpeed
    emitterCell.xAcceleration = emitterConfiguration.acceleration.x
    emitterCell.yAcceleration = emitterConfiguration.acceleration.y
    emitterCell.zAcceleration = emitterConfiguration.acceleration.z
    emitterCell.velocity = emitterConfiguration.velocity
    emitterCell.velocityRange = emitterConfiguration.velocityRange
    emitterCell.alphaSpeed = Float(emitterConfiguration.alphaSpeed)
    emitterCell.alphaRange = Float(emitterConfiguration.alphaRange)
    emitterCell.redRange = Float(emitterConfiguration.redRange)
    emitterCell.redSpeed = Float(emitterConfiguration.redSpeed)
    emitterCell.greenRange = Float(emitterConfiguration.greenRange)
    emitterCell.greenSpeed = Float(emitterConfiguration.greenSpeed)
    emitterCell.blueRange = Float(emitterConfiguration.blueRange)
    emitterCell.blueSpeed = Float(emitterConfiguration.blueSpeed)
    emitterCell.lifetime = Float(emitterConfiguration.lifetime)
    emitterCell.lifetimeRange = Float(emitterConfiguration.lifetimeRange)

    emitterCell.setValue(emitterConfiguration.particleType.rawValue,
                                    forKey: "particleType")
    emitterCell.setValue(Double(emitterConfiguration.orientationRange),
                                    forKey: "orientationRange")
    emitterCell.setValue(Double(emitterConfiguration.orientationLongitude),
                                    forKey: "orientationLongitude")
    emitterCell.setValue(Double(emitterConfiguration.orientationLatitude),
                                    forKey: "orientationLatitude")

    emitterLayer.emitterCells = [emitterCell]
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
