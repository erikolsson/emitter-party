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

struct EmitterConfiguration: Equatable {
  var emitterShape = EmitterShape.rectangle
  var emitterPosition: CGPoint = CGPoint(x: 500, y: 0)
  var emitterSize: CGPoint = CGPoint(x: 500, y: 0)
  var birthRate: CGFloat = 1
  var emitterCells: IdentifiedArrayOf<EmitterCellConfiguration> = [
    EmitterCellConfiguration()
  ]

  var animations: IdentifiedArrayOf<EmitterAnimationConfiguration> = []
}

enum EmitterAction: Equatable {
  case emitterCell(id: UUID, action: EmitterCellAction)
  case animation(id: UUID, action: EmitterAnimationAction)
  case bindingAction(BindingAction<EmitterConfiguration>)
  case addEmitterCell
  case addAnimation
}

let emitterReducer = Reducer<EmitterConfiguration, EmitterAction, AppEnvironment>
  .combine(
    emitterCellReducer.forEach(state: \.emitterCells,
                               action: /EmitterAction.emitterCell(id:action:), environment: {$0}),
    emitterAnimationReducer.forEach(state: \.animations,
                                    action: /EmitterAction.animation(id:action:), environment: {$0}),
    Reducer({
      (state, action, env) -> Effect<EmitterAction, Never> in
      switch action {
      case .addEmitterCell:
        let newEmitter = EmitterCellConfiguration()
        state.emitterCells.insert(newEmitter, at: 0)
        return .none

      case .addAnimation:
        state.animations.insert(EmitterAnimationConfiguration(), at: 0)
        return .none

      case let .animation(id: id, action: .remove):
        state.animations.remove(id: id)
        return .none

      case let .emitterCell(id: id, action: .remove):
        state.emitterCells.remove(id: id)
        return .none

      default:
        return .none
      }
    })
  )
  .binding(action: /EmitterAction.bindingAction)
