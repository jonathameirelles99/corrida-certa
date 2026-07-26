import SwiftUI

struct VerdictBanner: View {
    let result: RideVerdictResult

    var body: some View {
        VStack(spacing: 16) {
            Text(result.verdict.rawValue)
                .font(.title.bold())
                .foregroundStyle(.white)

            HStack(spacing: 24) {
                metric(title: "R$/km", value: result.netValuePerKm)
                metric(title: "R$/h", value: result.netValuePerHour)
            }

            if result.estimatedFuelCost > 0 {
                Text("Combustível estimado: R$ \(result.estimatedFuelCost, specifier: "%.2f")")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Theme.color(for: result.verdict))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func metric(title: String, value: Double) -> some View {
        VStack {
            Text("R$ \(value, specifier: "%.2f")")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}

#Preview {
    let offer = RideOffer(grossValue: 18.5, distanceKm: 8.2, durationMinutes: 22)
    let result = EarningsCalculator.evaluate(offer: offer, settings: .default)
    return VerdictBanner(result: result)
        .background(Theme.background)
}
