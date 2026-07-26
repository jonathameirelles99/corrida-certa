import Foundation

/// Motor de cálculo central do Corrida Certa.
/// Recebe uma oferta extraída (via OCR) e as metas do usuário,
/// e devolve o veredito com todas as métricas relevantes.
enum EarningsCalculator {

    static func evaluate(offer: RideOffer, settings: UserSettings) -> RideVerdictResult {
        let hours = offer.durationMinutes / 60.0

        let grossPerKm = safeDivide(offer.grossValue, offer.distanceKm)
        let grossPerHour = safeDivide(offer.grossValue, hours)

        var fuelCost = 0.0
        if settings.deductFuelCost, settings.kmPerLiter > 0 {
            let litersUsed = offer.distanceKm / settings.kmPerLiter
            fuelCost = litersUsed * settings.fuelPricePerLiter
        }

        let netValue = offer.grossValue - fuelCost
        let netPerKm = safeDivide(netValue, offer.distanceKm)
        let netPerHour = safeDivide(netValue, hours)

        let verdict = classify(netPerKm: netPerKm, netPerHour: netPerHour, settings: settings)

        return RideVerdictResult(
            offer: offer,
            grossValuePerKm: grossPerKm,
            grossValuePerHour: grossPerHour,
            netValue: netValue,
            netValuePerKm: netPerKm,
            netValuePerHour: netPerHour,
            estimatedFuelCost: fuelCost,
            verdict: verdict
        )
    }

    /// Uma corrida só é "boa" se atingir AMBAS as metas (R$/km e R$/h).
    /// Se atingir só uma das duas, é classificada como neutra.
    /// Se não atingir nenhuma, é ruim.
    private static func classify(netPerKm: Double, netPerHour: Double, settings: UserSettings) -> Verdict {
        let meetsKmGoal = netPerKm >= settings.minValuePerKm
        let meetsHourGoal = netPerHour >= settings.minValuePerHour

        switch (meetsKmGoal, meetsHourGoal) {
        case (true, true):
            return .good
        case (false, false):
            return .bad
        default:
            return .neutral
        }
    }

    private static func safeDivide(_ numerator: Double, _ denominator: Double) -> Double {
        guard denominator > 0 else { return 0 }
        return numerator / denominator
    }
}
