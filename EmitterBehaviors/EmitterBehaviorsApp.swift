//
//  EmitterBehaviorsApp.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture

@main
struct EmitterBehaviorsApp: App {

  @State var showFilePicker = false
  var store = Store(initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment())

  var body: some Scene {
    WithViewStore(store) { viewStore in


      WindowGroup {
        ContentView(store: store)
          .sheet(isPresented: $showFilePicker, content: {
            PickerView(url: nil) { (url) in
              viewStore.send(.openURL(url))
            }
          })
      }
      .commands {
        CommandGroup(before: CommandGroupPlacement.saveItem) {
          Button("Open") {
            showFilePicker = true
          }
        }
      }
    }
  }
}
