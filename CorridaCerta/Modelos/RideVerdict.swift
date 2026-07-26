import Foundation

/// Classificação final da corrida em relação às metas do usuário.
enum Verdict: String, Codable {
    case good = "Boa corrida"
    case bad = "Corrida ruim"
    case neutral = "Dentro da média"
}

/// Resultado completo do motor de cálculo para uma oferta específica.
struct RideVerdictResult: Identifiable, Codable, Equatable {
    let id: UUID
    let offer: RideOffer

    /// Ganho bruto por km (sem descontos).
    let grossValuePerKm: Double

    /// Ganho bruto por hora (sem descontos).
    let grossValuePerHour: Double

    /// Ganho líquido total, após desconto de combustível (se ativado).
    let netValue: Double

    /// Ganho líquido por km, após desconto de combustível (se ativado).
    let netValuePerKm: Double

    /// Ganho líquido por hora, após desconto de combustível (se ativado).
    let netValuePerHour: Double

    /// Custo estimado de combustível para essa corrida (0 se desativado).
    let estimatedFuelCost: Double

    let verdict: Verdict

    init(
        id: UUID = UUID(),
        offer: RideOffer,
        grossValuePerKm: Double,
        grossValuePerHour: Double,
        netValue: Double,
        netValuePerKm: Double,
        netValuePerHour: Double,
        estimatedFuelCost: Double,
        verdict: Verdict
    ) {
        self.id = id
        self.offer = offer
        self.grossValuePerKm = grossValuePerKm
        self.grossValuePerHour = grossValuePerHour
        self.netValue = netValue
        self.netValuePerKm = netValuePerKm
        self.netValuePerHour = netValuePerHour
        self.estimatedFuelCost = estimatedFuelCost
        self.verdict = verdict
    }
}
