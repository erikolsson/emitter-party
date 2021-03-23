//
//  EmitterConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import SwiftUI
import ComposableArchitecture

struct EmitterConfigurationView: View {
  let store: Store<EmitterConfiguration, EmitterAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading, spacing: 20) {
        Menu(viewStore.emitterShape.rawValue.capitalized) {
          ForEach(EmitterShape.allCases, id: \.self) { type in
            Button(type.rawValue.capitalized) {
              viewStore.send(.bindingAction(.set(\.emitterShape, type)))
            }
          }
        }

        CGPointView(label: "Emitter Position",
                    value: viewStore.binding(keyPath: \.emitterPosition,
                                             send: EmitterAction.bindingAction))

        CGPointView(label: "Emitter Size",
                    value: viewStore.binding(keyPath: \.emitterSize,
                                             send: EmitterAction.bindingAction))

        CGFloatView(label: "Birthrate",
                    value: viewStore.binding(keyPath: \.birthRate,
                                             send: EmitterAction.bindingAction))
        
      }
      .padding(.all, 10)
    }
    .padding([.top, .bottom], 10)
  }
}
