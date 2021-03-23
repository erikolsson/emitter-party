//
//  ComponentListView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-23.
//

import SwiftUI
import ComposableArchitecture

struct ComponentListView: View {

  let store: Store<AppState, AppAction>

  var body: some View {
    Form {
      WithViewStore(store) { viewStore in
        NavigationLink(
          destination: ConfigurationView(store: store),
          label: {
            Text("Emitter Settings")
          })

        Section(header: Text("Emitter Cells")) {
          ForEach(viewStore.emitter.emitterCells) { cell in
            NavigationLink(
              destination: IfLetStore(
                store.scope(state: \.emitter, action: AppAction.emitter)
                  .scope(state: { $0.emitterCells[id: cell.id] } , action: { EmitterAction.emitterCell(id: cell.id, action: $0)})
              ) { emitterCellStore in
                EmitterCellConfigurationView(store: emitterCellStore)
              },
              label: {
                Text("\(cell.contents.rawValue.capitalized)")
              })
          }
          Button("Add Cell") {
            viewStore.send(.emitter(.addEmitterCell))
          }.buttonStyle(BorderlessButtonStyle())
        }

        Section(header: Text("Behaviors")) {
          ForEach(viewStore.behaviors) { behavior in
            NavigationLink(
              destination: IfLetStore(store.scope(state: { $0.behaviors[id: behavior.id] },
                                                  action: { AppAction.behavior(id: behavior.id, action: $0) })) { store in
                             BehaviorSettingsView(store:store)
                           },
              label: {
                Text("\(behavior.behaviorType.title)")
              })
          }

          Button("Add Behavior") {
            viewStore.send(.add)
          }.buttonStyle(BorderlessButtonStyle())
        }

        Section(header: Text("Animations")) {
          ForEach(viewStore.emitter.animations) { animation in
            NavigationLink(
              destination: IfLetStore(
                store.scope(state: \.emitter, action: AppAction.emitter)
                  .scope(state: { $0.animations[id: animation.id] } , action: { EmitterAction.animation(id: animation.id, action: $0)})
              ) { animationStore in
                AnimationConfigurationView(store: animationStore)
              },
              label: {
                Text("\(animation.key.rawValue)")
              })
          }

          Button("Add Animation") {
            viewStore.send(.emitter(.addAnimation))
          }
          .buttonStyle(BorderlessButtonStyle())
        }
      }
      .listStyle(SidebarListStyle())
    }
  }
}
