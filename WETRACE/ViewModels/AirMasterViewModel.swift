//
//  AirMasterViewModel.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
class AirMasterViewModel {
    var scores: [ButeykoScore] = []
    var pcTimerValue: Double = 0.0
    var isPCRunning = false

    private var timerTask: Task<Void, Never>?
    private var startTime: Date?

    func startPCTimer() {
        pcTimerValue = 0.0
        isPCRunning = true
        startTime = Date()
        HapticManager.instance.triggerLight()

        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                if let start = self.startTime {
                    self.pcTimerValue = Date().timeIntervalSince(start)
                }
            }
        }
    }

    func stopAndSavePC() {
        isPCRunning = false
        timerTask?.cancel()
        timerTask = nil
        if pcTimerValue > 0 {
            let newScore = ButeykoScore(date: Date(), seconds: pcTimerValue)
            scores.insert(newScore, at: 0)
            HapticManager.instance.triggerSuccess()
        }
    }

    var lastSevenDaysScores: [ButeykoScore] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return scores.filter { $0.date >= sevenDaysAgo }.reversed()
    }
}
