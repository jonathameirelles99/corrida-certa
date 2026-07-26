import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    goalRow(
                        title: "Meta mínima de R$/km",
                        value: $store.settings.minValuePerKm,
                        suffix: "R$"
                    )
                    goalRow(
                        title: "Meta mínima de R$/h",
                        value: $store.settings.minValuePerHour,
                        suffix: "R$"
                    )
                } header: {
                    Text("Suas metas")
                } footer: {
                    Text("Uma corrida só é marcada como boa quando atinge as duas metas ao mesmo tempo.")
                }

                Section {
                    Toggle("Descontar custo de combustível", isOn: $store.settings.deductFuelCost)

                    if store.settings.deductFuelCost {
                        goalRow(
                            title: "Consumo médio (km por litro)",
                            value: $store.settings.kmPerLiter,
                            suffix: "km/l"
                        )
                        goalRow(
                            title: "Preço do combustível (por litro)",
                            value: $store.settings.fuelPricePerLiter,
                            suffix: "R$"
                        )
                    }
                } header: {
                    Text("Custo do veículo (opcional)")
                } footer: {
                    Text("Quando ativado, o ganho líquido considera o gasto estimado de combustível de cada corrida.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Corrida Certa")
        }
        .tint(Theme.accentGreen)
    }

    @ViewBuilder
    private func goalRow(title: String, value: Binding<Double>, suffix: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField(
                "",
                value: value,
                format: .number.precision(.fractionLength(2))
            )
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .frame(width: 80)
            Text(suffix)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsStore())
        .preferredColorScheme(.dark)
}
