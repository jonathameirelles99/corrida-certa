import XCTest
@testable import CorridaCerta

final class EarningsCalculatorTests: XCTestCase {

    func testGoodRideMeetsBothGoals() {
        let offer = RideOffer(grossValue: 30, distanceKm: 10, durationMinutes: 20)
        var settings = UserSettings.default
        settings.minValuePerKm = 1.0
        settings.minValuePerHour = 20.0
        settings.deductFuelCost = false

        let result = EarningsCalculator.evaluate(offer: offer, settings: settings)

        XCTAssertEqual(result.grossValuePerKm, 3.0, accuracy: 0.001)
        XCTAssertEqual(result.grossValuePerHour, 90.0, accuracy: 0.001)
        XCTAssertEqual(result.verdict, .good)
    }

    func testBadRideMissesBothGoals() {
        let offer = RideOffer(grossValue: 8, distanceKm: 12, durationMinutes: 40)
        var settings = UserSettings.default
        settings.minValuePerKm = 1.2
        settings.minValuePerHour = 25.0

        let result = EarningsCalculator.evaluate(offer: offer, settings: settings)

        XCTAssertEqual(result.verdict, .bad)
    }

    func testFuelDeductionReducesNetValue() {
        let offer = RideOffer(grossValue: 20, distanceKm: 10, durationMinutes: 15)
        var settings = UserSettings.default
        settings.deductFuelCost = true
        settings.kmPerLiter = 10.0
        settings.fuelPricePerLiter = 6.0

        let result = EarningsCalculator.evaluate(offer: offer, settings: settings)

        // 10km / 10km-por-litro = 1 litro * R$6 = R$6 de custo
        XCTAssertEqual(result.estimatedFuelCost, 6.0, accuracy: 0.001)
        XCTAssertEqual(result.netValue, 14.0, accuracy: 0.001)
    }

    func testZeroDistanceDoesNotCrash() {
        let offer = RideOffer(grossValue: 15, distanceKm: 0, durationMinutes: 10)
        let result = EarningsCalculator.evaluate(offer: offer, settings: .default)

        XCTAssertEqual(result.grossValuePerKm, 0)
    }
}
