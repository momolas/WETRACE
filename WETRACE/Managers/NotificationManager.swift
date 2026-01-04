//
//  NotificationManager.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()

    private init() {}

    func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func scheduleMorningReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🌅 Test PC du Matin"
        content.body = "C'est le moment de mesurer votre Pause de Contrôle."

        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_pc", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
