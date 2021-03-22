//
//  Emitter.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture
import UIKit

enum EmitterShape: String, CaseIterable, Identifiable, Equatable {
  var id: String {
    rawValue
  }
  case circle
  case rectangle
  case cuboid
  case line
  case point
  case sphere
}

struct Emitter: Equatable {
  var emitterShape = EmitterShape.rectangle
  var emitterPosition: CGPoint = CGPoint(x: 500, y: 0)
  var emitterSize: CGPoint = CGPoint(x: 500, y: 0)
  var birthRate: CGFloat = 1
}

enum EmitterAction: Equatable {
  case bindingAction(BindingAction<Emitter>)
}

let emitterReducer = Reducer<Emitter, EmitterAction, AppEnvironment> {
  (state, action, env) -> Effect<EmitterAction, Never> in
  return .none
}.binding(action: /EmitterAction.bindingAction)
