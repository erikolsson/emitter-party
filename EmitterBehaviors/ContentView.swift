//
//  ContentView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  @State var targeted: Bool = false
  let store: Store<AppState, AppAction>
  var body: some View {
    ZStack {
      HStack(spacing: 0) {
        ComponentListView(store: store)
          .frame(width: 260)
          .zIndex(1)
        EmitterViewRepresentable(store: store)
      }

      HStack {
        Spacer()
        WithViewStore(store) { viewStore in
          switch viewStore.selectedComponent {
          case .emitter:
            EmitterConfigurationView(store: store.scope(state: \.emitter,
                                                        action: AppAction.emitter))

          case .emitterCell(let id):
            IfLetEmitterCellView(id: id,
                                 store: store.scope(state: \.emitter,
                                                    action: AppAction.emitter))
          case let .animation(id: id):
            IfLetAnimationView(id: id, store: store.scope(state: \.emitter,
                                                          action: AppAction.emitter))
          case let .behavior(id: id):
            IfLetBehaviorView(id: id, store: store)
          default:
            EmptyView()
          }
        }
        .frame(width: 290)
      }
    }
  }
}

struct IfLetEmitterCellView: View {
  let id: UUID
  let store: Store<EmitterConfiguration, EmitterAction>
  var body: some View {
    IfLetStore(store.scope(state: \.emitterCells[id: id], action: { EmitterAction.emitterCell(id: id, action: $0)})) { (cellStore) in
      EmitterCellConfigurationView(store: cellStore)
    }
  }
}

struct IfLetAnimationView: View {
  let id: UUID
  let store: Store<EmitterConfiguration, EmitterAction>
  var body: some View {
    IfLetStore(store.scope(state: \.animations[id: id], action: { EmitterAction.animation(id: id, action: $0)})) { (cellStore) in
      AnimationConfigurationView(store: cellStore)
    }
  }
}

struct IfLetBehaviorView: View {
  let id: UUID
  let store: Store<AppState, AppAction>

  var body: some View {
    IfLetStore(store.scope(state: \.behaviors[id: id], action: {AppAction.behavior(id: id, action: $0)} )) { behaviorStore in
      BehaviorConfigurationView(store: behaviorStore)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(store: Store(initialState: AppState(),
                             reducer: appReducer,
                             environment: AppEnvironment()))
  }
}
