import Foundation

/// Interpreta o texto bruto extraído via OCR da tela de oferta de corrida
/// (Uber/99) e converte em um RideOffer estruturado.
enum OfferTextParser {

    static func parse(rawText: String, platform: RidePlatform = .unknown) -> RideOffer? {
        guard let value = extractCurrencyValue(from: rawText) else { return nil }
        guard let distance = extractDistanceKm(from: rawText) else { return nil }
        let duration = extractTotalMinutes(from: rawText)
        guard duration > 0 else { return nil }

        return RideOffer(
            grossValue: value,
            distanceKm: distance,
            durationMinutes: duration,
            sourcePlatform: platform
        )
    }

    static func extractCurrencyValue(from text: String) -> Double? {
        let pattern = #"R\$\s?(\d{1,3}(?:\.\d{3})*,\d{2})"#
        guard let match = firstMatch(pattern, in: text) else { return nil }
        return parseBrazilianNumber(match)
    }

    static func extractDistanceKm(from text: String) -> Double? {
        let pattern = #"(\d+[.,]?\d*)\s?km"#
        guard let match = firstMatch(pattern, in: text) else { return nil }
        return parseBrazilianNumber(match)
    }

    /// Soma TODAS as ocorrências de "X min" encontradas no texto.
    /// As plataformas costumam mostrar o tempo até o passageiro e o tempo
    /// da corrida em separado — somar os dois dá o percurso total real,
    /// que é o que importa pro cálculo de R$/h.
    static func extractTotalMinutes(from text: String) -> Double {
        let pattern = #"(\d+)\s?min"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return 0 }
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        var total = 0.0
        for match in matches {
            guard let r = Range(match.range(at: 1), in: text) else { continue }
            total += Double(text[r]) ?? 0
        }
        return total
    }

    private static func firstMatch(_ pattern: String, in text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let r = Range(match.range(at: 1), in: text) else { return nil }
        return String(text[r])
    }

    /// Converte números no formato brasileiro ("1.234,56") para Double.
    private static func parseBrazilianNumber(_ raw: String) -> Double? {
        let normalized = raw
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }
}
