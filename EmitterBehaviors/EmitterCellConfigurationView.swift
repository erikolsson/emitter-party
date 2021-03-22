//
//  EmitterConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-22.
//

import SwiftUI
import ComposableArchitecture

struct EmitterCellConfigurationView: View {

  let store: Store<EmitterCell, EmitterCellAction>
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {

        Group {
          Menu(viewStore.particleType.rawValue) {
            ForEach(ParticleType.allCases, id: \.self) { type in
              Button(type.rawValue) {
                viewStore.send(.bindingAction(.set(\.particleType, type)))
              }
            }
          }

          CGFloatView(label: "Orientation Range",
                      value: viewStore.binding(keyPath: \.orientationRange,
                                               send: EmitterCellAction.bindingAction))
          CGFloatView(label: "Orientation Longitude",
                      value: viewStore.binding(keyPath: \.orientationLongitude,
                                               send: EmitterCellAction.bindingAction))
          CGFloatView(label: "Orientation Latitude",
                      value: viewStore.binding(keyPath: \.orientationLatitude,
                                               send: EmitterCellAction.bindingAction))

          Divider()
        }

        Group {
          CGFloatView(label: "Scale",
                      value: viewStore.binding(keyPath: \.scale,
                                               send: EmitterCellAction.bindingAction))
          CGFloatView(label: "Scale Range",
                      value: viewStore.binding(keyPath: \.scaleRange,
                                               send: EmitterCellAction.bindingAction))
          CGFloatView(label: "Scale Speed",
                      value: viewStore.binding(keyPath: \.scaleSpeed,
                                               send: EmitterCellAction.bindingAction))

          Divider()
        }

        Group {
          CGFloatView(label: "Spin", value: viewStore.binding(keyPath: \.spin, send: EmitterCellAction.bindingAction))
          CGFloatView(label: "y-Acceleration", value: viewStore.binding(keyPath: \.yAcceleration, send: EmitterCellAction.bindingAction))
          //        CGFloatView(label: "spinRange", value: viewStore.binding(keyPath: \.spinRange, send: EmitterAction.bindingAction))
          //        CGFloatView(label: "velocity", value: viewStore.binding(keyPath: \.velocity, send: EmitterAction.bindingAction))
          //        CGFloatView(label: "velocityRange", value: viewStore.binding(keyPath: \.velocityRange, send: EmitterAction.bindingAction))
          //        CGFloatView(label: "xAcceleration", value: viewStore.binding(keyPath: \.xAcceleration, send: EmitterAction.bindingAction))
          //        CGFloatView(label: "zAcceleration", value: viewStore.binding(keyPath: \.zAcceleration, send: EmitterAction.bindingAction))
          //        CGFloatView(label: "emissionRange", value: viewStore.binding(keyPath: \.emissionRange, send: EmitterAction.bindingAction))
          CGFloatView(label: "BirthRate",
                      value: viewStore.binding(keyPath: \.birthRate,
                                               send: EmitterCellAction.bindingAction))
          CGFloatView(label: "Lifetime",
                      value: viewStore.binding(keyPath: \.lifetime,
                                               send: EmitterCellAction.bindingAction))
          VStack {
//            Text("Color").font(.subheadline)
            ColorPicker("Color", selection: viewStore.binding(keyPath: \.color,
                                                              send: EmitterCellAction.bindingAction))
          }
        }
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
