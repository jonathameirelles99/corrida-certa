import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MonitorView()
                .tabItem {
                    Label("Monitor", systemImage: "gauge.with.dots.needle.50percent")
                }

            SettingsView()
                .tabItem {
                    Label("Configurações", systemImage: "slider.horizontal.3")
                }
        }
        .tint(Theme.accentGreen)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsStore())
}
