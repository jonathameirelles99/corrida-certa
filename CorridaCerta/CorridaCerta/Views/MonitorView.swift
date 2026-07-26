import SwiftUI

/// Tela que mostra o veredito em tempo real assim que a extensão de
/// captura de tela detecta e analisa uma oferta.
struct MonitorView: View {
    @EnvironmentObject var store: SettingsStore
    @State private var lastResult: RideVerdictResult?

    private let refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let result = lastResult {
                    VerdictBanner(result: result)
                        .transition(.opacity)
                } else {
                    waitingState
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Monitor")
            .onAppear(perform: refresh)
            .onReceive(refreshTimer) { _ in refresh() }
        }
        .onAppear {
            SharedStore.observeNewResults { [self] in
                DispatchQueue.main.async { refresh() }
            }
        }
    }

    private var waitingState: some View {
        VStack(spacing: 24) {
            Image(systemName: "gauge.with.dots.needle.50percent")
                .font(.system(size: 64))
                .foregroundStyle(Theme.accentGreen)

            Text("Aguardando corridas")
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)

            Text("Ative a gravação de tela pela Central de Controle e escolha Corrida Certa como destino. As ofertas serão analisadas automaticamente.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private func refresh() {
        if let latest = SharedStore.loadLatestResult() {
            withAnimation { lastResult = latest }
        }
    }
}

#Preview {
    MonitorView()
        .environmentObject(SettingsStore())
        .preferredColorScheme(.dark)
}
