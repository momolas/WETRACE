//
//  BreathStep.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import Foundation

enum BreathStep: String {
    case inhale = "Inspirer"
    case hold = "Retenir"
    case hum = "Bourdonner"
    case pause = "Repos"

    var duration: Double {
        switch self {
        case .inhale: return 4.0
        case .hold: return 4.0
        case .hum: return 6.0
        case .pause: return 2.0
        }
    }
}
