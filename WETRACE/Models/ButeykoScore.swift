//
//  ButeykoScore.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import SwiftUI

struct ButeykoScore: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let seconds: Double

    var formattedDate: String {
        date.formatted(date: .numeric, time: .shortened)
    }

    var statusColor: Color {
        if seconds < 20 { return .red }
        if seconds < 40 { return .orange }
        return .green
    }
}
