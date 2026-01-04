//
//  Exercise.swift
//  WETRACE
//
//  Created by Jules on 04/01/2026.
//

import Foundation

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}
