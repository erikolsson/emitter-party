//
//  EmitterBehavior.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture
import UIKit

enum AttractorType: String, CaseIterable, Identifiable, Equatable, Codable {
  var id: String {
    self.rawValue
  }

  case radial
  case axial
  case planar
}

enum EmitterBehaviorType: String, CaseIterable, Identifiable, Equatable, Codable {
  case wave
  case drag
  case alignToMotion
  case attractor

  var id: String {
    return self.rawValue
  }

  var title: String {
    switch self {
    case .wave:
      return "Wave"
    case .drag:
      return "Drag"
    case .alignToMotion:
      return "Align to motion"
    case .attractor:
      return "Attractor"
    }
  }
}

struct Vector3: Equatable, Codable {
  var x: CGFloat
  var y: CGFloat
  var z: CGFloat

  static let zero = { return Vector3(x: 0, y: 0, z: 0) }()
}

struct EmitterBehaviorConfiguration: Codable, Equatable, Identifiable {

  let id = UUID()
  var behaviorType: EmitterBehaviorType

  var force: Vector3 = .zero
  var frequency: CGFloat = 0
  var drag: CGFloat = 0

  var rotation: CGFloat = 0
  var preservesDepth = false

  var attractorType = AttractorType.radial
  var stiffness: Double = 0
  var radius: Double = 0
  var position: Vector3 = .zero
  var falloff: Double = 0
  var orientationLatitude: Double = 0
  var orientationLongitude: Double = 0
}

enum EmitterBehaviorAction: Equatable {
  case bindingAction(BindingAction<EmitterBehaviorConfiguration>)
  case remove
}

let emitterBehaviorReducer = Reducer<EmitterBehaviorConfiguration, EmitterBehaviorAction, AppEnvironment>{
  (state, action, _) -> Effect<EmitterBehaviorAction, Never> in

  return .none
}
.binding(action: /EmitterBehaviorAction.bindingAction)
