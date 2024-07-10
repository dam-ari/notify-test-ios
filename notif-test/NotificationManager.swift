//
//  NotificationManager.swift
//  notif-test
//
//  Created by Bareket Damari on 10/07/2024.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var notificationsSent: Int = 0
    @Published var currentInterval: Double?
    @Published var currentUnit: TimeUnit?
    private var notificationIdentifier: String?

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }

    func scheduleNotification(interval: Double, unit: TimeUnit, title: String = "Custom Interval Reminder", body: String = "This is your reminder.") {
        stopNotifications()  // Replaced cancelPreviousNotification with stopNotifications
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let timeInterval = interval * unit.timeInterval
        let trigger: UNNotificationTrigger

        if timeInterval >= 60 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            scheduleRepeatingNotification(interval: timeInterval, title: title, body: body)
        }

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        self.notificationIdentifier = identifier
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.notificationsSent += 1
                    self.currentInterval = interval
                    self.currentUnit = unit
                }
                print("Notification scheduled successfully")
            }
        }
    }

    private func scheduleRepeatingNotification(interval: TimeInterval, title: String, body: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.scheduleNotification(interval: interval / TimeUnit.seconds.timeInterval, unit: .seconds, title: title, body: body)
        }
    }

    func checkNotificationPermissionAndSchedule(interval: Double, unit: TimeUnit, title: String = "Custom Interval Reminder", body: String = "This is your reminder.") {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.scheduleNotification(interval: interval, unit: unit, title: title, body: body)
            } else {
                print("Notification permission not granted")
            }
        }
    }

    func scheduleOneTimeNotification(interval: Double, unit: TimeUnit, title: String = "One-Time Reminder", body: String = "This is your one-time reminder.") {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let timeInterval = interval * unit.timeInterval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling one-time notification: \(error.localizedDescription)")
            } else {
                print("One-time notification scheduled successfully")
            }
        }
    }

    func stopNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        notificationIdentifier = nil
        DispatchQueue.main.async {
            self.notificationsSent = 0
            self.currentInterval = nil
            self.currentUnit = nil
        }
    }
}
extension NotificationManager {
    func scheduleHourlyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hourly Reminder"
        content.body = "This is your hourly reminder."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        let request = UNNotificationRequest(identifier: "hourlyNotification", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
//    func checkNotificationPermissionAndSchedule() {
//        let center = UNUserNotificationCenter.current()
//        center.getNotificationSettings { settings in
//            if settings.authorizationStatus == .authorized {
//                self.scheduleHourlyNotification()
//            } else {
//                print("Notification permission not granted")
//            }
//        }
//    }
}
