//
//  ConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture

struct NumericTextField<Value: BinaryFloatingPoint>: View where Value.Stride : BinaryFloatingPoint {


  let minValue: Value
  let maxValue: Value

  @Binding var value: Value
  var allowsDecimals = false
  var body: some View {
    TextField("0.0", text: .init(get: {
      if allowsDecimals {
        return String(format: "%0.1f", CGFloat(value))
      } else {
        return String(format: "%0.0f", CGFloat(value))
      }
    }, set: { (str) in
      self.value = Value(Double(str) ?? 0)
    })).keyboardType(.numbersAndPunctuation)
    .foregroundColor(Color.white)
    .padding([.top, .bottom], 2)
    .frame(width: 60)
    .multilineTextAlignment(.center)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .foregroundColor(Color.black.opacity(0.4))
    ).overlay(
      RoundedRectangle(cornerRadius: 4)
        .stroke(Color.black)
    ).padding([.top, .bottom], 3)

  }

}

struct Vector3View: View {

  let label: String
  @Binding var value: Vector3

  var body: some View {
    VStack {
      HStack {
        Text(label).font(.subheadline)
          .padding([.bottom], 2)
        Spacer()
      }
      HStack {
        Text("X").font(.subheadline)
        NumericTextField(minValue: 0, maxValue: 10, value: $value.x)
        Spacer()
        Text("Y").font(.subheadline)
        NumericTextField(minValue: 0, maxValue: 10, value: $value.y)
        Spacer()
        Text("Z").font(.subheadline)
        NumericTextField(minValue: 0, maxValue: 10, value: $value.z)
      }
    }
    .padding([.top, .bottom], 5)
  }

}

struct SliderWithTextField<Value: BinaryFloatingPoint>: View where Value.Stride : BinaryFloatingPoint {
  let title: String
  @Binding var value: Value
  let minValue: Value
  let maxValue: Value

  var body: some View {
    VStack(alignment: .leading) {
      Text(title).font(.subheadline)
      HStack {
        Slider(value: $value,
               in: minValue...maxValue) {
          Text("Scale Speed")
        }
        NumericTextField(minValue: 0, maxValue: 1, value: $value, allowsDecimals: true)
      }
    }.padding([.top, .bottom], 5)
  }

}


struct CGFloatView: View {
  let label: String
  @Binding var value: CGFloat

  var body: some View {
    HStack(alignment: .center) {
      Text(label).font(.subheadline)
      Spacer(minLength: 10)
      NumericTextField(minValue: 0, maxValue: 10, value: $value)
    }
  }
}

struct CGPointView: View {
  let label: String
  @Binding var value: CGPoint

  var body: some View {
    VStack(alignment: .leading) {
      Text(label).font(.subheadline).bold()
      HStack {
        Text("X").font(.subheadline)
        NumericTextField(minValue: 0, maxValue: 10, value: $value.x)
        Spacer()
        Text("Y").font(.subheadline)
        NumericTextField(minValue: 0, maxValue: 10, value: $value.y)
      }
    }
  }
}

struct BehaviorConfigurationView: View {

  let store: Store<EmitterBehaviorConfiguration, EmitterBehaviorAction>

  var body: some View {

    List {
      WithViewStore(store) { viewStore in
        VStack(alignment: .leading, spacing: 5) {

          HStack {
            Menu(viewStore.behaviorType.title) {
              ForEach(EmitterBehaviorType.allCases, id: \.self) { type in
                Button(type.title) {
                  viewStore.send(.bindingAction(.set(\.behaviorType, type)))
                }
              }
            }
            Spacer()
            Button("Remove", action: { viewStore.send(.remove) })
              .buttonStyle(BorderlessButtonStyle())
          }
          Divider()

          if viewStore.behaviorType == .wave {
            WaveConfigurationView(store: store)
          }

          if viewStore.behaviorType == .drag {
            DragConfigurationView(store: store)
          }

          if viewStore.behaviorType == .alignToMotion {
            AlignToMotionConfigurationView(store: store)
          }

          if viewStore.behaviorType == .attractor {
            AttractorConfigurationView(store: store)
          }

          Spacer()
        }
        .padding(.all, 10)
      }
    }
  }

}

struct WaveConfigurationView: View {
  let store: Store<EmitterBehaviorConfiguration, EmitterBehaviorAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      Vector3View(label: "Force",
                  value: viewStore.binding(keyPath: \.force,
                                           send: EmitterBehaviorAction.bindingAction))
      SliderWithTextField(title: "Frequency",
                          value: viewStore.binding(keyPath: \.frequency,
                                                   send: EmitterBehaviorAction.bindingAction),
                          minValue: 0,
                          maxValue: 5)
    }
  }

}

struct DragConfigurationView: View {
  let store: Store<EmitterBehaviorConfiguration, EmitterBehaviorAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      SliderWithTextField(title: "Drag",
                          value: viewStore.binding(keyPath: \.drag,
                                                   send: EmitterBehaviorAction.bindingAction),
                          minValue: 0,
                          maxValue: 1)
    }
  }

}

struct AlignToMotionConfigurationView: View {
  let store: Store<EmitterBehaviorConfiguration, EmitterBehaviorAction>

  var body: some View {
    WithViewStore(store) { viewStore in
        SliderWithTextField(title: "Rotation",
                            value: viewStore.binding(keyPath: \.rotation,
                                                     send: EmitterBehaviorAction.bindingAction),
                            minValue: 0,
                            maxValue: .pi * 2)

      Toggle("Preserves Depth",
             isOn: viewStore.binding(keyPath: \.preservesDepth,
                                     send: EmitterBehaviorAction.bindingAction))
    }
  }

}

struct AttractorConfigurationView: View {
  let store: Store<EmitterBehaviorConfiguration, EmitterBehaviorAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      
      Menu(viewStore.attractorType.rawValue) {
        ForEach(AttractorType.allCases, id: \.self) { type in
          Button(type.rawValue) {
            viewStore.send(.bindingAction(.set(\.attractorType, type)))
          }
        }
      }
      
      
      
      SliderWithTextField(title: "Stiffness",
                          value: viewStore.binding(keyPath: \.stiffness,
                                                   send: EmitterBehaviorAction.bindingAction),
                          minValue: -30,
                          maxValue: 30)
      
      SliderWithTextField(title: "Radius",
                          value: viewStore.binding(keyPath: \.radius,
                                                   send: EmitterBehaviorAction.bindingAction),
                          minValue: 0,
                          maxValue: 300)
      
      Vector3View(label: "Position",
                  value: viewStore.binding(keyPath: \.position,
                                           send: EmitterBehaviorAction.bindingAction))
      
      SliderWithTextField(title: "Falloff",
                          value: viewStore.binding(keyPath: \.falloff,
                                                   send: EmitterBehaviorAction.bindingAction),
                          minValue: -300,
                          maxValue: 300)

      if viewStore.attractorType != .radial {
        SliderWithTextField(title: "Orientation Latitude",
                            value: viewStore.binding(keyPath: \.orientationLatitude,
                                                     send: EmitterBehaviorAction.bindingAction),
                            minValue: -Double.pi,
                            maxValue: .pi)

        SliderWithTextField(title: "Orientation Longitude",
                            value: viewStore.binding(keyPath: \.orientationLongitude,
                                                     send: EmitterBehaviorAction.bindingAction),
                            minValue: -Double.pi,
                            maxValue: .pi)
      }
    }
  }
}
