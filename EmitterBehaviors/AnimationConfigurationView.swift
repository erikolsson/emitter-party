//
//  AnimationConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import SwiftUI
import ComposableArchitecture

struct AnimationConfigurationView: View {

  let store: Store<EmitterAnimation, EmitterAnimationAction>
  var body: some View {
    List {

      WithViewStore(store) { viewStore in
        Button("Remove") {
          viewStore.send(.remove)
        }.buttonStyle(BorderlessButtonStyle())

        Text("Keypath: birthRate")
        SliderWithTextField(title: "From Value",
                            value: viewStore.binding(keyPath: \.fromValue,
                                                     send: EmitterAnimationAction.bindingAction),
                            minValue: 0,
                            maxValue: 10)

        SliderWithTextField(title: "To Value",
                            value: viewStore.binding(keyPath: \.toValue,
                                                     send: EmitterAnimationAction.bindingAction),
                            minValue: 0,
                            maxValue: 10)

        SliderWithTextField(title: "Duration",
                            value: viewStore.binding(keyPath: \.duration,
                                                     send: EmitterAnimationAction.bindingAction),
                            minValue: 0,
                            maxValue: 10)
      }
    }
  }
}
