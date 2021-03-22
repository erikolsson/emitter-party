//
//  ContentView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

  let store: Store<AppState, AppAction>
  var body: some View {
    HStack {
      EmitterViewRepresentable(store: store)
      ConfigurationView(store: store)
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(store: Store(initialState: AppState(),
                             reducer: appReducer,
                             environment: AppEnvironment()))
  }
}
