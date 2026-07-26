import Foundation

/// Configurações definidas pelo usuário: suas metas mínimas e,
/// opcionalmente, o custo do veículo para calcular o ganho líquido.
struct UserSettings: Codable, Equatable {
    /// Meta mínima de ganho por quilômetro (R$/km) para considerar a corrida boa.
    var minValuePerKm: Double

    /// Meta mínima de ganho por hora (R$/h) para considerar a corrida boa.
    var minValuePerHour: Double

    /// Se true, o app desconta o custo estimado de combustível do ganho bruto.
    var deductFuelCost: Bool

    /// Consumo médio do veículo, em km por litro.
    var kmPerLiter: Double

    /// Preço atual do combustível, em R$ por litro.
    var fuelPricePerLiter: Double

    static let `default` = UserSettings(
        minValuePerKm: 1.20,
        minValuePerHour: 25.0,
        deductFuelCost: false,
        kmPerLiter: 10.0,
        fuelPricePerLiter: 6.00
    )
}
