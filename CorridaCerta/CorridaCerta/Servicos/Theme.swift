import SwiftUI

enum Theme {
    static let background = Color(red: 0.06, green: 0.08, blue: 0.09)
    static let surface = Color(red: 0.11, green: 0.13, blue: 0.14)
    static let accentGreen = Color(red: 0.55, green: 0.85, blue: 0.20)
    static let alertRed = Color(red: 0.90, green: 0.30, blue: 0.25)
    static let neutralYellow = Color(red: 0.95, green: 0.75, blue: 0.20)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)

    static func color(for verdict: Verdict) -> Color {
        switch verdict {
        case .good: return accentGreen
        case .bad: return alertRed
        case .neutral: return neutralYellow
        }
    }
}
