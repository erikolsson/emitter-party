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
    VStack(alignment: .leading) {
      ParticleConfigurationView(store: store)
      VelocityConfigurationView(store: store)
      ScaleConfigurationView(store: store)
      BirthRateLifetimeConfigurationView(store: store)
      ColorConfigurationView(store: store)
      AlphaConfigurationView(store: store)
    }
    .padding([.top, .bottom], 10)
  }
}

struct ScaleConfigurationView: View {
  let store: Store<EmitterCell, EmitterCellAction>
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        SliderWithTextField(title: "Scale",
                            value: viewStore.binding(keyPath: \.scale, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)
        SliderWithTextField(title: "Scale Range",
                            value: viewStore.binding(keyPath: \.scaleRange, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 2)
        SliderWithTextField(title: "Scale Speed",
                            value: viewStore.binding(keyPath: \.scaleSpeed, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)
        Divider()
      }
    }
  }
}

struct AlphaConfigurationView: View {
  let store: Store<EmitterCell, EmitterCellAction>
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        SliderWithTextField(title: "Alpha",
                            value: viewStore.binding(keyPath: \.alpha, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Alpha Range",
                            value: viewStore.binding(keyPath: \.alphaRange, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Alpha Speed",
                            value: viewStore.binding(keyPath: \.alphaSpeed, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Red Range",
                            value: viewStore.binding(keyPath: \.redRange, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Red Speed",
                            value: viewStore.binding(keyPath: \.redSpeed, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Green Range",
                            value: viewStore.binding(keyPath: \.greenRange, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Green Speed",
                            value: viewStore.binding(keyPath: \.greenSpeed, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Blue Range",
                            value: viewStore.binding(keyPath: \.blueRange, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)

        SliderWithTextField(title: "Blue Speed",
                            value: viewStore.binding(keyPath: \.blueSpeed, send: EmitterCellAction.bindingAction),
                            minValue: 0,
                            maxValue: 1)
      }
    }
  }
}

struct OrientationView: View {

  let store: Store<EmitterCell, EmitterCellAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
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
      }
    }
  }
}

struct ParticleConfigurationView: View {

  let store: Store<EmitterCell, EmitterCellAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      
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
      OrientationView(store: store)
      Divider()
    }
  }

}

struct VelocityConfigurationView: View {

  let store: Store<EmitterCell, EmitterCellAction>

  var body: some View {
    WithViewStore(store) { viewStore in

      SliderWithTextField(title: "Velocity",
                          value: viewStore.binding(keyPath: \.velocity,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: -100,
                          maxValue: 100)

      SliderWithTextField(title: "Velocity Range",
                          value: viewStore.binding(keyPath: \.velocityRange,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: 0,
                          maxValue: 200)

      Vector3View(label: "Acceleration",
                  value: viewStore.binding(keyPath: \.acceleration,
                                           send: EmitterCellAction.bindingAction))

      SliderWithTextField(title: "Spin",
                          value: viewStore.binding(keyPath: \.spin,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: -20,
                          maxValue: 20)

      SliderWithTextField(title: "Spin Range",
                          value: viewStore.binding(keyPath: \.spinRange,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: 0,
                          maxValue: 20)

      Divider()
    }
  }
}

struct ColorConfigurationView: View {
  let store: Store<EmitterCell, EmitterCellAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      ColorPicker("Color", selection: viewStore.binding(keyPath: \.color,
                                                        send: EmitterCellAction.bindingAction))
    }
  }
}

struct BirthRateLifetimeConfigurationView: View {
  let store: Store<EmitterCell, EmitterCellAction>
  var body: some View {
    WithViewStore(store) { viewStore in
      SliderWithTextField(title: "Birthrate",
                          value: viewStore.binding(keyPath: \.birthRate,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: 0,
                          maxValue: 100)

      SliderWithTextField(title: "Lifetime",
                          value: viewStore.binding(keyPath: \.lifetime,
                                                   send: EmitterCellAction.bindingAction),
                          minValue: 0,
                          maxValue: 20)
    }
  }
}
