//
//  ComponentListView.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-23.
//

import SwiftUI
import ComposableArchitecture
import UIKit

struct ComponentListView: View {

  let store: Store<AppState, AppAction>
  var body: some View {
    List {
      WithViewStore(store) { viewStore in
        Button(action: {
          viewStore.send(.selectEmitter)
        }, label: {
          Text("Emitter")
            .font(.headline)
            .padding([.top, .bottom], 5)
        })
        .listRowBackground(viewStore.state.emitterSelected ? Color(white: 0.3, opacity: 1) : Color.clear)

        EmitterCellsSection(store: store)
        BehaviorsSection(store: store)
        AnimationsSection(store: store)

//        .sheet(isPresented: viewStore.binding(get: { $0.showFilePicker },
//                                               send: { (s) -> AppAction in
//                                                .hideFilePicker
//                                               }), content: {
//                                                FilePickerController(url: viewStore.saveFile) { (url) in
//                                                  print(url)
//                                                }
//                                               })
      }
    }
    .listStyle(PlainListStyle())
  }
}

extension ComponentListView: DropDelegate {

  func dropEntered(info: DropInfo) {
    print(info)
  }

  func dropUpdated(info: DropInfo) -> DropProposal? {
    print("entered")
    return nil //s DropProposal(operation: .move)
  }

  func performDrop(info: DropInfo) -> Bool {
    print(info)
    return true
  }
}

struct SectionHeader: View {
  let title: String
  let action: () -> Void

  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
      Spacer()
      Button(action: {
        action()
      }, label: {
        Image(systemName: "plus.circle")
      })
      .buttonStyle(BorderlessButtonStyle())

    }
    .foregroundColor(.white)
    .padding([.top, .bottom], 10)
  }
}

struct EmitterCellsSection: View {

  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      Section(header:
                SectionHeader(title: "Emitter Cells", action: {
                  viewStore.send(.emitter(.addEmitterCell))
                })) {
        ForEach(viewStore.emitter.emitterCells) { cell in

          Button(cell.contents.rawValue.capitalized) {
            viewStore.send(.selectEmitterCell(cell.id))
          }
          .listRowBackground(viewStore.state.isSelected(emitterCell: cell) ? Color(white: 0.3, opacity: 1) : Color.clear)
        }
      }
    }
  }
}

struct AnimationsSection: View {

  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      Section(header: SectionHeader(title: "Animations", action: {
        viewStore.send(.emitter(.addAnimation))
      })) {
        ForEach(viewStore.emitter.animations) { animation in

          Button(animation.key.rawValue) {
            viewStore.send(.selectAnimation(animation.id))
          }
          .listRowBackground(viewStore.state.isSelected(animation: animation) ? Color(white: 0.3, opacity: 1) : Color.clear)

        }
      }
    }
  }
}

struct BehaviorsSection: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      Section(header: SectionHeader(title: "Behaviors", action: {
        viewStore.send(.addBehavior)
      })) {
        ForEach(viewStore.behaviors) { behavior in
          Button(behavior.emitterTypeName.capitalized) {
            viewStore.send(.selectBehavior(behavior.id))
          }
          .listRowBackground(viewStore.state.isSelected(behavior: behavior) ? Color(white: 0.3, opacity: 1) : Color.clear)
        }
      }
    }
  }
}



