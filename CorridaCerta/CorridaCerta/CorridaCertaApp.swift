import SwiftUI

@main
struct CorridaCertaApp: App {
    @StateObject private var settingsStore = SettingsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStore)
                .onAppear {
                    NotificationService.requestAuthorizationIfNeeded()
                }
        }
    }
}
