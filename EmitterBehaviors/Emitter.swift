//
//  Emitter.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture
import UIKit
import SwiftUI

struct Emitter: Equatable {

  var contents: CGImage? = UIImage(named: "default-emitter")?.cgImage
  var color: Color = .purple
  var scale: CGFloat = 1
  var scaleRange: CGFloat = 0.2
  var scaleSpeed: CGFloat = 0.03
  var spin: CGFloat = 0.3
  var spinRange: CGFloat = 0.1
  var velocity: CGFloat = 10
  var velocityRange: CGFloat = 8
  var xAcceleration: CGFloat = 0.2
  var zAcceleration: CGFloat = 50
  var emissionRange: CGFloat = 6.28
  var birthRate: CGFloat = 10
  var lifetime: CGFloat = 5
  var lifetimeRange: CGFloat = 4

}

enum EmitterAction: Equatable {
  case bindingAction(BindingAction<Emitter>)
}

let emitterReducer = Reducer<Emitter, EmitterAction, AppEnvironment> {
  (state, action, _) -> Effect<EmitterAction, Never> in
  return .none
}
.binding(action: /EmitterAction.bindingAction)
