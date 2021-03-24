//
//  SaveConfiguration.swift
//  EmitterBehaviors
//
//  Created by Erik Olsson on 2021-03-23.
//

import Foundation

struct EmitterViewConfiguration: Codable, Equatable {
  let emitter: EmitterConfiguration
  let behaviors: [EmitterBehaviorConfiguration]
}
