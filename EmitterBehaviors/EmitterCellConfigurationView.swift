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
      VStack(alignment: .leading) {
        Group {
          Menu(viewStore.particleType.rawValue) {
            ForEach(ParticleType.allCases, id: \.self) { type in
              Button(type.rawValue) {
                viewStore.send(.bindingAction(.set(\.particleType, type)))
              }
            }
          }

          Divider()
          Text("Particle Contents").font(.subheadline)
          Menu(viewStore.contents.rawValue) {
            ForEach(ParticleContents.allCases, id: \.self) { type in
              Button(type.rawValue) {
                viewStore.send(.bindingAction(.set(\.contents, type)))
              }
            }
          }

          if viewStore.showOrientations {
            VStack {
              CGFloatView(label: "Orientation Range",
                          value: viewStore.binding(keyPath: \.orientationRange,
                                                   send: EmitterCellAction.bindingAction))
              CGFloatView(label: "Orientation Longitude",
                          value: viewStore.binding(keyPath: \.orientationLongitude,
                                                   send: EmitterCellAction.bindingAction))
              CGFloatView(label: "Orientation Latitude",
                          value: viewStore.binding(keyPath: \.orientationLatitude,
                                                   send: EmitterCellAction.bindingAction))
            }
          }
          Divider()
        }

        Group {

          VStack(alignment: .leading) {
            Text("Scale").font(.subheadline)
            HStack {
              Slider(value: viewStore.binding(keyPath: \.scale,
                                              send: EmitterCellAction.bindingAction),
                     in: 0...2) {
                Text("Scale")
              }
              NumericTextField(minValue: 0, maxValue: 1, value: viewStore.binding(keyPath: \.scale,
                                                                                  send: EmitterCellAction.bindingAction))
            }
          }

          VStack(alignment: .leading) {
            Text("Scale Range").font(.subheadline)
            HStack {
              Slider(value: viewStore.binding(keyPath: \.scaleRange,
                                              send: EmitterCellAction.bindingAction),
                     in: 0...2) {
                Text("Scale Range")
              }
              NumericTextField(minValue: 0, maxValue: 1, value: viewStore.binding(keyPath: \.scaleRange,
                                                                                  send: EmitterCellAction.bindingAction))
            }
          }


          VStack(alignment: .leading) {
            Text("Scale Speed").font(.subheadline)
            HStack {
              Slider(value: viewStore.binding(keyPath: \.scaleSpeed,
                                              send: EmitterCellAction.bindingAction),
                     in: 0...2) {
                Text("Scale Speed")
              }
              NumericTextField(minValue: 0, maxValue: 1, value: viewStore.binding(keyPath: \.scaleSpeed,
                                                                                  send: EmitterCellAction.bindingAction))
            }
          }

          Divider()
        }

        Group {
          CGFloatView(label: "Spin", value: viewStore.binding(keyPath: \.spin, send: EmitterCellAction.bindingAction))
          Divider()
        }
        Group {

          Vector3View(label: "Acceleration", value: viewStore.binding(keyPath: \.acceleration,
                                                                     send: EmitterCellAction.bindingAction))
          Divider()

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
          VStack(alignment: .leading) {
//            Text("Color").font(.subheadline)
            ColorPicker("Color", selection: viewStore.binding(keyPath: \.color,
                                                              send: EmitterCellAction.bindingAction))
          }

          VStack(alignment: .leading) {
            Text("Alpha").font(.subheadline)
            HStack {
              Slider(value: viewStore.binding(keyPath: \.alpha,
                                              send: EmitterCellAction.bindingAction),
                     in: 0...1) {
                Text("Alpha")
              }
              NumericTextField(minValue: 0, maxValue: 1, value: viewStore.binding(keyPath: \.alpha,
                                                                                  send: EmitterCellAction.bindingAction))
            }
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
      .padding(.all, 10)
    }
    .padding([.top, .bottom], 10)

  }
}
