//
//  EmitterAnimations.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture
import UIKit

enum EmitterAnimationKey: String, Equatable, Identifiable, CaseIterable, Codable {

  var id: String {
    rawValue
  }

  case birthRate
}


struct EmitterAnimationConfiguration: Codable, Equatable, Identifiable {
  let id = UUID()
  var fromValue: CGFloat = 1
  var toValue: CGFloat = 0
  var duration: CGFloat = 1
  var key = EmitterAnimationKey.birthRate
}

enum EmitterAnimationAction: Equatable {
  case remove
  case bindingAction(BindingAction<EmitterAnimationConfiguration>)
}

let emitterAnimationReducer = Reducer<EmitterAnimationConfiguration, EmitterAnimationAction, AppEnvironment> { (state, action, env) -> Effect<EmitterAnimationAction, Never> in
  return .none
}
.binding(action: /EmitterAnimationAction.bindingAction)
