//
//  EmitterAnimations.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import ComposableArchitecture

enum EmitterAnimationKey: String, Equatable, Identifiable, CaseIterable {

  var id: String {
    rawValue
  }

  case birthRate
}


struct EmitterAnimation: Equatable, Identifiable {
  let id = UUID()
  var fromValue: CGFloat = 1
  var toValue: CGFloat = 0
  var duration: CGFloat = 1
  var key = EmitterAnimationKey.birthRate
}

enum EmitterAnimationAction: Equatable {
  case remove
  case bindingAction(BindingAction<EmitterAnimation>)
}

let emitterAnimationReducer = Reducer<EmitterAnimation, EmitterAnimationAction, AppEnvironment> { (state, action, env) -> Effect<EmitterAnimationAction, Never> in
  return .none
}
.binding(action: /EmitterAnimationAction.bindingAction)
