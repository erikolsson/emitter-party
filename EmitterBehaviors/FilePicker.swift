//
//  FilePicker.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-24.
//

import SwiftUI
import UIKit

struct FilePickerController: UIViewControllerRepresentable {

  let url: URL?
  var callback: (URL) -> ()

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
    // Update the controller
  }

  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    print("Making the picker")

    let controller: UIDocumentPickerViewController
    if let url = url {
      controller = UIDocumentPickerViewController(forExporting: [url])
    } else {
      controller = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
    }
    controller.delegate = context.coordinator
    print("Setup the delegate \(context.coordinator)")

    return controller
  }

  class Coordinator: NSObject, UIDocumentPickerDelegate {
    var parent: FilePickerController

    init(_ pickerController: FilePickerController) {
      self.parent = pickerController
    }


    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      if urls.count > 0 {
        parent.callback(urls[0])
      }
    }

    func documentPickerWasCancelled() {

    }

    deinit {
      print("deinint")
    }
  }
}

struct FilePickerView: View {
  var url: URL?
  var callback: (URL) -> ()
  var body: some View {
    FilePickerController(url: url, callback: callback)
  }
}
