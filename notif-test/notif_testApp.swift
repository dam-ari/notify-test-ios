//
//  notif_testApp.swift
//  notif-test
//
//  Created by Bareket Damari on 10/07/2024.
//

import SwiftUI

@main
struct notif_testApp: App {
    @StateObject private var notificationManager = NotificationManager()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .onAppear {
                        notificationManager.requestNotificationPermission()
//                        notificationManager.checkNotificationPermissionAndSchedule(interval: 1.0, unit: .minutes)
                    }
                    .badge(notificationManager.notificationsSent)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .environmentObject(notificationManager)
                TimerSettingsView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
                    .environmentObject(notificationManager)
            }
        }
    }
}
