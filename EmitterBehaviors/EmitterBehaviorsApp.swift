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

  var store = Store(initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment())

  var body: some Scene {
    WithViewStore(store) { viewStore in

      WindowGroup {
        ContentView(store: store)
          .sheet(item: viewStore.binding(
            get: {$0.ioState},
            send: AppAction.hideFilePicker
          )) { (state) in
            switch state {
            case let .saveFile(targetURL):
              FilePickerView(url: targetURL) { (url) in
                viewStore.send(.openURL(url))
              }
            case .open:
              FilePickerView(url: nil) { (url) in
                viewStore.send(.openURL(url))
              }
            }
          }.environment(\.colorScheme, .dark)
      }
      .commands {
        CommandGroup(before: .saveItem) {
          Menu("Examples") {
            ForEach(AppExample.allCases) { (example) in
              Button(example.rawValue.capitalized) {
                viewStore.send(.loadExample(example))
              }
            }
          }
        }
        CommandGroup(before: CommandGroupPlacement.saveItem) {
          Button("Open") {
            viewStore.send(.open)
          }.keyboardShortcut(KeyEquivalent("o"), modifiers: .command)

          Button("Save") {
            viewStore.send(.save)
          }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
        }
      }
    }
  }
}
