//
//  Emitter.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture
import UIKit
import SwiftUI

enum ParticleType: String, CaseIterable, Identifiable, Equatable {
  var id: String {
    rawValue
  }

  case sprite
  case plane

}
struct EmitterCell: Equatable {

  var particleType = ParticleType.plane
  var contents: CGImage? = UIImage(named: "default-emitter")?.cgImage
  var color: Color = .purple
  var scale: CGFloat = 1
  var scaleRange: CGFloat = 0.2
  var scaleSpeed: CGFloat = 0.03
  var spin: CGFloat = 0.3
  var spinRange: CGFloat = 0.1
  var velocity: CGFloat = 10
  var velocityRange: CGFloat = 8
  var yAcceleration: CGFloat = 150
  var xAcceleration: CGFloat = 0.2
  var zAcceleration: CGFloat = 50
  var emissionRange: CGFloat = 6.28
  var birthRate: CGFloat = 10
  var lifetime: CGFloat = 5
  var lifetimeRange: CGFloat = 4

  var orientationRange: CGFloat = .pi
  var orientationLongitude: CGFloat = .pi / 2
  var orientationLatitude: CGFloat = .pi / 2
}

enum EmitterCellAction: Equatable {
  case bindingAction(BindingAction<EmitterCell>)
}

let emitterCellReducer = Reducer<EmitterCell, EmitterCellAction, AppEnvironment> {
  (state, action, _) -> Effect<EmitterCellAction, Never> in
  return .none
}
.binding(action: /EmitterCellAction.bindingAction)
