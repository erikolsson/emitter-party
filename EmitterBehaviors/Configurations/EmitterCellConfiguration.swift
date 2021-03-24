//
//  Emitter.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture
import UIKit
import SwiftUI

enum ParticleContents: String, CaseIterable, Identifiable, Equatable, Codable {
  case square
  case rectangle
  case arrow
  case circle
  case heart

  var id: String {
    rawValue
  }

  var image: UIImage? {
    switch self {
    case .arrow:
      return UIImage(named: "default-emitter-arrow")
    case .rectangle:
      return UIImage(named: "default-emitter-rectangle")
    case .square:
      return UIImage(named: "default-emitter-square")
    case .circle:
      return UIImage(named: "default-emitter-circle")
    case .heart:
      return UIImage(named: "default-emitter-heart")
    }
  }

}

enum ParticleType: String, CaseIterable, Identifiable, Equatable, Codable {
  var id: String {
    rawValue
  }

  case sprite
  case plane
}

struct EmitterCellConfiguration: Identifiable, Equatable, Codable {
  var id = UUID()
  var particleType = ParticleType.plane
  var contents = ParticleContents.rectangle
  var color: Color = .purple
  var alpha: CGFloat = 1

  var alphaSpeed: Float = 1
  var alphaRange: Float = 0
  var redSpeed: Float = 0
  var redRange: Float = 0
  var greenSpeed: Float = 0
  var greenRange: Float = 0
  var blueSpeed: Float = 0
  var blueRange: Float = 0
  
  var scale: CGFloat = 1
  var scaleRange: CGFloat = 0.2
  var scaleSpeed: CGFloat = 0.03
  var spin: CGFloat = 0.3
  var spinRange: CGFloat = 0.1
  var velocity: CGFloat = 10
  var velocityRange: CGFloat = 8
  var acceleration: Vector3 = Vector3(x: 0, y: 150, z: 0)
  var emissionRange: CGFloat = 6.28
  var birthRate: Float = 10
  var lifetime: Float = 5
  var lifetimeRange: Float = 4

  var orientationRange: Double = .pi
  var orientationLongitude: Double = .pi / 2
  var orientationLatitude: Double = .pi / 2
}

enum EmitterCellAction: Equatable {
  case remove
  case bindingAction(BindingAction<EmitterCellConfiguration>)
}

let emitterCellReducer = Reducer<EmitterCellConfiguration, EmitterCellAction, AppEnvironment> {
  (state, action, _) -> Effect<EmitterCellAction, Never> in
  return .none
}
.binding(action: /EmitterCellAction.bindingAction)

extension EmitterCellConfiguration {
  var showOrientations: Bool {
    return particleType == .plane
  }
}
