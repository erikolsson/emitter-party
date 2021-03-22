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
  var emitterCells: IdentifiedArrayOf<EmitterCell> = [
    EmitterCell()
  ]
}

enum EmitterAction: Equatable {
  case emitterCell(id: UUID, action: EmitterCellAction)
  case bindingAction(BindingAction<Emitter>)
  case addEmitterCell
}

let emitterReducer = Reducer<Emitter, EmitterAction, AppEnvironment>
  .combine(
    emitterCellReducer.forEach(state: \.emitterCells,
                               action: /EmitterAction.emitterCell(id:action:), environment: {$0}),
    Reducer({
      (state, action, env) -> Effect<EmitterAction, Never> in
      switch action {
      case .addEmitterCell:
        let newEmitter = EmitterCell()
        state.emitterCells.insert(newEmitter, at: 0)
        return .none
      default:
        return .none
      }
    })
  )
  .binding(action: /EmitterAction.bindingAction)
