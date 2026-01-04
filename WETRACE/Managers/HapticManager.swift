//
//  HapticManager.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import UIKit

class HapticManager {
    static let instance = HapticManager()

    private init() {}

    func triggerLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func triggerSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
