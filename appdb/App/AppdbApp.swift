//
//  AppdbApp.swift
//  appdb
//
//  Created by ned on 07/01/23.
//

import SwiftUI

@main
struct AppdbApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    AppsView(type: .ios)
                        .navigationTitle("Apps")
                }
                .tabItem {
                    Label("Apps", systemImage: "star")
                }
                
                NavigationStack {
                    AppsView(type: .cydia)
                        .navigationTitle("Custom")
                }
                .tabItem {
                    Label("Custom", systemImage: "star")
                }

                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}
