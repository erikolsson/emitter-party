//
//  EmitterBehavior.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture
import UIKit

enum AttractorType: String, CaseIterable, Identifiable, Equatable {
  var id: String {
    self.rawValue
  }

  case radial
  case axial
  case planar
}

enum EmitterBehaviorType: String, CaseIterable, Identifiable, Equatable {
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

struct Vector3: Equatable {
  var x: CGFloat
  var y: CGFloat
  var z: CGFloat

  static let zero = { return Vector3(x: 0, y: 0, z: 0) }()
}

struct EmitterBehaviorConfiguration: Equatable, Identifiable {

  let id = UUID()
  var behaviorType: EmitterBehaviorType

  var force: Vector3 = .zero
  var frequency: CGFloat = 0
  var drag: CGFloat = 0

  var rotation: CGFloat = 0
  var preservesDepth = false

  var attractorType = AttractorType.radial
  var stiffness: Float = 0
  var radius: Float = 0
  var position: Vector3 = .zero
  var falloff: Float = 0

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
.debug()

extension EmitterBehaviorConfiguration {

  var showForce: Bool {
    switch self.behaviorType {
    case .wave:
      return true
    default:
      return false
    }
  }

  var showFrequency: Bool {
    switch self.behaviorType {
    case .wave:
      return true
    default:
      return false
    }
  }

  var showDrag: Bool {
    switch self.behaviorType {
    case .drag:
      return true
    default:
      return false
    }
  }

  var showRotation: Bool {
    switch self.behaviorType {
    case .alignToMotion:
      return true
    default:
      return false
    }
  }

  var showPreservesDepth: Bool {
    switch self.behaviorType {
    case .alignToMotion:
      return true
    default:
      return false
    }
  }

  var showAttractorType: Bool {
    switch self.behaviorType {
    case .attractor:
      return true
    default:
      return false
    }
  }

  var showStiffness: Bool {
    switch self.behaviorType {
    case .attractor:
      return true
    default:
      return false
    }
  }

  var showRadius: Bool {
    switch self.behaviorType {
    case .attractor:
      return true
    default:
      return false
    }
  }

  var showPosition: Bool {
    switch self.behaviorType {
    case .attractor:
      return true
    default:
      return false
    }
  }

  var showFalloff: Bool {
    switch self.behaviorType {
    case .attractor:
      return true
    default:
      return false
    }
  }

  var showColor: Bool {
    return false
  }

}
