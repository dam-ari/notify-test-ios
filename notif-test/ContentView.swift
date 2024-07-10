//
//  ContentView.swift
//  notif-test
//
//  Created by Bareket Damari on 10/07/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Text("Notifications Sent: \(notificationManager.notificationsSent)")
                .padding()
            if let interval = notificationManager.currentInterval, let unit = notificationManager.currentUnit {
                Text("Current Schedule: Every \(Int(interval)) \(unit.pluralized(for: interval))")
                    .padding()
            } else {
                Text("No schedule set")
                    .padding()
            }
        }
        .onAppear {
            // Force a re-render to ensure the latest data is fetched
            _ = notificationManager.notificationsSent
            _ = notificationManager.currentInterval
            _ = notificationManager.currentUnit
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotificationManager())
}
