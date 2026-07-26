import Foundation

/// Representa uma oferta de corrida extraída automaticamente da tela
/// (via OCR) do app de transporte (Uber, 99, etc).
struct RideOffer: Identifiable, Codable, Equatable {
    let id: UUID
    let capturedAt: Date

    /// Valor bruto oferecido pela plataforma, em reais.
    let grossValue: Double

    /// Distância total estimada da corrida, em quilômetros.
    let distanceKm: Double

    /// Duração total estimada da corrida, em minutos.
    let durationMinutes: Double

    /// Plataforma de origem da oferta, quando identificável.
    var sourcePlatform: RidePlatform

    init(
        id: UUID = UUID(),
        capturedAt: Date = Date(),
        grossValue: Double,
        distanceKm: Double,
        durationMinutes: Double,
        sourcePlatform: RidePlatform = .unknown
    ) {
        self.id = id
        self.capturedAt = capturedAt
        self.grossValue = grossValue
        self.distanceKm = distanceKm
        self.durationMinutes = durationMinutes
        self.sourcePlatform = sourcePlatform
    }
}

enum RidePlatform: String, Codable, CaseIterable {
    case uber = "Uber"
    case ninetyNine = "99"
    case unknown = "Desconhecida"
}
