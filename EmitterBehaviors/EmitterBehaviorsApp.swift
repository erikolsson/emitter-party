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
  var body: some Scene {
    WindowGroup {
      ContentView(store: Store(initialState: AppState(),
                               reducer: appReducer,
                               environment: AppEnvironment()))
    }
  }
}
