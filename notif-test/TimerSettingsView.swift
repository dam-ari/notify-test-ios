//
//  TimerSettingsView.swift
//  notif-test
//
//  Created by Bareket Damari on 10/07/2024.
//

import SwiftUI

struct TimerSettingsView: View {
    @State private var interval: Double = 1
    @State private var unit: TimeUnit = .minutes
    @State private var showSuccessMessage = false
    @State private var successMessage: String = ""
    @State private var notificationTitle: String = "Custom Interval Reminder"
    @State private var notificationBody: String = "This is your reminder."
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        VStack {
            Text("Set Notification Interval")
                .font(.headline)
                .padding()

            HStack {
                Text("Every")
                TextField("Interval", value: $interval, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                Picker("Unit", selection: $unit) {
                    ForEach(TimeUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            HStack {
                Text("Title")
                TextField("Title", text: $notificationTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            HStack {
                Text("Body")
                TextField("Body", text: $notificationBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            Button("Schedule Notification") {
                notificationManager.scheduleNotification(interval: interval, unit: unit, title: notificationTitle, body: notificationBody)
                successMessage = "Notification schedule updated to be pushed each \(Int(interval)) \(unit.pluralized(for: interval)) successfully!"
                showSuccessMessage = true
            }
            .padding()

            Button("Schedule One-Time Notification") {
                notificationManager.scheduleOneTimeNotification(interval: interval, unit: unit, title: "ontime", body: notificationBody)
                successMessage = "One-time notification scheduled successfully!"
                showSuccessMessage = true
            }
            .padding()

            Button("Stop Notifications") {
                notificationManager.stopNotifications()
                successMessage = "Notifications stopped successfully!"
                showSuccessMessage = true
            }
            .padding()
            .foregroundColor(.red)

            if showSuccessMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            notificationManager.requestNotificationPermission()
        }
    }
}

enum TimeUnit: String, CaseIterable {
    case seconds = "Seconds"
    case minutes = "Minutes"
    case hours = "Hours"

    var timeInterval: TimeInterval {
        switch self {
        case .seconds:
            return 1
        case .minutes:
            return 60
        case .hours:
            return 3600
        }
    }
    
    func pluralized(for interval: Double) -> String {
        if interval == 1 {
            return String(self.rawValue.dropLast()) // Remove the 's' for singular
        } else {
            return self.rawValue
        }
    }
}

#Preview {
    TimerSettingsView()
        .environmentObject(NotificationManager())
}
