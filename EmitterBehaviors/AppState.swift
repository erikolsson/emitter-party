//
//  AppState.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import Swift
import ComposableArchitecture

enum SelectedComponent: Equatable {
  case none
  case emitter
  case emitterCell(id: UUID)
  case behavior(id: UUID)
  case animation(id: UUID)
}

struct AppState: Equatable {
  var emitter = EmitterConfiguration()
  var behaviors: IdentifiedArrayOf<EmitterBehaviorConfiguration> = []

  var selectedComponent = SelectedComponent.none
}

enum AppAction: Equatable {
  case selectBehavior(EmitterBehaviorConfiguration.ID)
  case selectEmitter
  case selectEmitterCell(EmitterCellConfiguration.ID)
  case selectAnimation(EmitterAnimationConfiguration.ID)
  case behavior(id: EmitterBehaviorConfiguration.ID, action: EmitterBehaviorAction)
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
    case .selectEmitter:
      state.selectedComponent = .emitter
      return .none

    case .selectBehavior(let id):
      state.selectedComponent = .behavior(id: id)
      return .none

    case .selectEmitterCell(let id):
      state.selectedComponent = .emitterCell(id: id)
      return .none

    case let .selectAnimation(id):
      state.selectedComponent = .animation(id: id)
      return .none

    case .add:
      state.behaviors.append(EmitterBehaviorConfiguration(behaviorType: .wave))
      return .none

    case let .behavior(id: id, action: .remove):
      state.behaviors.remove(id: id)
      return .none

    case .behavior, .emitterCell, .emitter:
      return .none
    }
  }

)


extension AppState {
  func isSelected(behavior: EmitterBehaviorConfiguration) -> Bool {
    switch selectedComponent {
    case let .behavior(id: id):
      return behavior.id == id
    default:
      return false
    }
  }

  func isSelected(animation: EmitterAnimationConfiguration) -> Bool {
    switch selectedComponent {
    case let .animation(id: id):
      return animation.id == id
    default:
      return false
    }
  }

  func isSelected(emitterCell: EmitterCellConfiguration) -> Bool {
    switch selectedComponent {
    case let .emitterCell(id: id):
      return emitterCell.id == id
    default:
      return false
    }
  }

  var emitterSelected: Bool {
    switch selectedComponent {
    case .emitter:
      return true
    default:
      return false
    }
  }
}


