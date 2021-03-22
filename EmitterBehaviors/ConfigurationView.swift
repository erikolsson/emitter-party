//
//  ConfigurationView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture

struct ConfigurationView: View {

  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      Form {

        Section(header: Text("Emitter")) {
          EmitterConfigurationView(store: store.scope(state: \.emitter,
                                                      action: AppAction.emitter))
        }

        Section(header: Text("Emitter Cells"), content: {
          EmitterCellConfigurationView(store: store.scope(state: \.emitterCell,
                                                      action: AppAction.emitterCell))
        })

        Section(header: Text("Behaviors")) {
          Button("Add New") {
            viewStore.send(.add)
          }
          ForEachStore(
            self.store.scope(state: \.behaviors,
                                        action: AppAction.behavior(id:action:))
          ) { behaviorStore in
            BehaviorSettingsView(store: behaviorStore)
          }
        }
      }
    }
  }

}


struct NumericTextField: View {

  let minValue: CGFloat
  let maxValue: CGFloat

  @Binding var value: CGFloat

  var body: some View {
    TextField("A", text: .init(get: {
      return String(format: "%0.1f", value)
    }, set: { (str) in
      self.value = CGFloat(Double(str) ?? 0)
    })).keyboardType(.numbersAndPunctuation)
    .foregroundColor(Color.black.opacity(0.8))
    .padding([.top, .bottom], 6)
    .frame(width: 60)
    .multilineTextAlignment(.center)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .foregroundColor(Color.white)
    ).overlay(
      RoundedRectangle(cornerRadius: 4)
        .stroke(Color.black)
    )

  }

}

struct Vector3View: View {

  let label: String
  @Binding var value: Vector3

  var body: some View {
    VStack(alignment: .leading) {
      Text(label).font(.subheadline)
      HStack {
        Text("X")
        NumericTextField(minValue: 0, maxValue: 10, value: $value.x)
        Text("Y")
        NumericTextField(minValue: 0, maxValue: 10, value: $value.y)
        Text("Z")
        NumericTextField(minValue: 0, maxValue: 10, value: $value.z)
      }
    }
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

struct BehaviorSettingsView: View {

  let store: Store<EmitterBehavior, EmitterBehaviorAction>

  var body: some View {
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
          Button("X", action: { viewStore.send(.remove) })
        }
        Divider()
        Group {
        if viewStore.showForce {
          Vector3View(label: "Force",
                      value: viewStore.binding(keyPath: \.force,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showFrequency {
          CGFloatView(label: "Frequency",
                      value: viewStore.binding(keyPath: \.frequency,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showDrag {
          CGFloatView(label: "Drag",
                      value: viewStore.binding(keyPath: \.drag,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showRotation {
          CGFloatView(label: "Rotation",
                      value: viewStore.binding(keyPath: \.rotation,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showPreservesDepth {
          Toggle("Preserves Depth",
                 isOn: viewStore.binding(keyPath: \.preservesDepth,
                                         send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showAttractorType {
          Menu(viewStore.attractorType.rawValue) {
            ForEach(AttractorType.allCases, id: \.self) { type in
              Button(type.rawValue) {
                viewStore.send(.bindingAction(.set(\.attractorType, type)))
              }
            }
          }
        }

        if viewStore.showStiffness {
          CGFloatView(label: "Stiffness",
                      value: viewStore.binding(keyPath: \.stiffness,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showRadius {
          CGFloatView(label: "Radius",
                      value: viewStore.binding(keyPath: \.radius,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showPosition {
          CGPointView(label: "Position",
                      value: viewStore.binding(keyPath: \.position,
                                               send: EmitterBehaviorAction.bindingAction))
        }

        if viewStore.showFalloff {
          CGFloatView(label: "Falloff",
                      value: viewStore.binding(keyPath: \.falloff,
                                               send: EmitterBehaviorAction.bindingAction))
        }
        }
      }
    }
  }

}
