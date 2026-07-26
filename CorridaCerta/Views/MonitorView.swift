import SwiftUI

/// Tela que mostrará o veredito em tempo real assim que a extensão de
/// captura de tela (Broadcast Upload Extension, Fase 2) estiver pronta.
/// Por enquanto exibe o estado de espera e explica ao usuário como ativar.
struct MonitorView: View {
    @EnvironmentObject var store: SettingsStore
    @State private var lastResult: RideVerdictResult?

    var body: some View {
        NavigationStack {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Monitor")
        }
    }
}

#Preview {
    MonitorView()
        .environmentObject(SettingsStore())
        .preferredColorScheme(.dark)
}
