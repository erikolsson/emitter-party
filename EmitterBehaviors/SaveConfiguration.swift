//
//  SaveConfiguration.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-23.
//

import Foundation

struct SaveConfiguration: Codable {
  let emitter: EmitterConfiguration
  let behaviors: [EmitterBehaviorConfiguration]
}
