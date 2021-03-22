//
//  EmitterConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import SwiftUI
import ComposableArchitecture

struct EmitterConfigurationView: View {

  let store: Store<Emitter, EmitterAction>
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {

        CGFloatView(label: "scale", value: viewStore.binding(keyPath: \.scale, send: EmitterAction.bindingAction))

        CGFloatView(label: "scaleRange", value: viewStore.binding(keyPath: \.scaleRange, send: EmitterAction.bindingAction))
        CGFloatView(label: "scaleSpeed", value: viewStore.binding(keyPath: \.scaleSpeed, send: EmitterAction.bindingAction))
        CGFloatView(label: "spin", value: viewStore.binding(keyPath: \.spin, send: EmitterAction.bindingAction))
//        CGFloatView(label: "spinRange", value: viewStore.binding(keyPath: \.spinRange, send: EmitterAction.bindingAction))
//        CGFloatView(label: "velocity", value: viewStore.binding(keyPath: \.velocity, send: EmitterAction.bindingAction))
//        CGFloatView(label: "velocityRange", value: viewStore.binding(keyPath: \.velocityRange, send: EmitterAction.bindingAction))
//        CGFloatView(label: "xAcceleration", value: viewStore.binding(keyPath: \.xAcceleration, send: EmitterAction.bindingAction))
//        CGFloatView(label: "zAcceleration", value: viewStore.binding(keyPath: \.zAcceleration, send: EmitterAction.bindingAction))
//        CGFloatView(label: "emissionRange", value: viewStore.binding(keyPath: \.emissionRange, send: EmitterAction.bindingAction))
//        CGFloatView(label: "birthRate", value: viewStore.binding(keyPath: \.birthRate, send: EmitterAction.bindingAction))
        CGFloatView(label: "lifetime", value: viewStore.binding(keyPath: \.lifetime, send: EmitterAction.bindingAction))
//        CGFloatView(label: "lifetimeRange", value: viewStore.binding(keyPath: \.lifetimeRange, send: EmitterAction.bindingAction))




  //      CGPointView(label: "Scale", value: vi)
  //      var scale: CGFloat = 1
  //      var scaleRange: CGFloat = 0.2
  //      var scaleSpeed: CGFloat = 0.03
  //      var spin: CGFloat = 0.3
  //      var spinRange: CGFloat = 0.1
  //      var velocity: CGFloat = 10
  //      var velocityRange: CGFloat = 8
  //      var xAcceleration: CGFloat = 0.2
  //      var zAcceleration: CGFloat = 50
  //      var emissionRange: CGFloat = 6.28
  //      var birthRate: CGFloat = 10
  //      var lifetime: CGFloat = 5
  //      var lifetimeRange: CGFloat = 4
      }
    }

  }
}
