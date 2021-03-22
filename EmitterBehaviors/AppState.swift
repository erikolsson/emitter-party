//
//  AppState.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import Swift
import ComposableArchitecture

struct AppState: Equatable {
  var emitter = Emitter()
  var behaviors: IdentifiedArrayOf<EmitterBehavior> = []
}

enum AppAction: Equatable {
  case behavior(id: EmitterBehavior.ID, action: EmitterBehaviorAction)
  case emitterCell(EmitterCellAction)
  case emitter(EmitterAction)
  case add
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  emitterBehaviorReducer.forEach(state: \.behaviors,
                                 action: /AppAction.behavior(id:action:), environment: {$0}),
  emitterReducer.pullback(state: \.emitter,
                          action: /AppAction.emitter,
                          environment: {$0}),
  Reducer<AppState, AppAction, AppEnvironment> {
    (state, action, env) -> Effect<AppAction, Never> in
    switch action {
    case .add:
      state.behaviors.append(EmitterBehavior(behaviorType: .wave))
      return .none

    case let .behavior(id: id, action: .remove):
      state.behaviors.remove(id: id)
      return .none

    case .behavior, .emitterCell, .emitter:
      return .none
    }
  }

)



