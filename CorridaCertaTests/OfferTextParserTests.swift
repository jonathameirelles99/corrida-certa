import XCTest
@testable import CorridaCerta

final class OfferTextParserTests: XCTestCase {

    func testParsesTypicalOfferText() throws {
        let text = """
        Nova oferta
        R$ 18,50
        8,3 km
        5 min
        17 min
        """
        let offer = try XCTUnwrap(OfferTextParser.parse(rawText: text))

        XCTAssertEqual(offer.grossValue, 18.50, accuracy: 0.001)
        XCTAssertEqual(offer.distanceKm, 8.3, accuracy: 0.001)
        // Soma dos dois trechos de tempo (até o passageiro + corrida): 5 + 17 = 22
        XCTAssertEqual(offer.durationMinutes, 22, accuracy: 0.001)
    }

    func testHandlesValueWithThousandsSeparator() throws {
        let text = "R$ 1.234,56\n12 km\n30 min"
        let value = try XCTUnwrap(OfferTextParser.extractCurrencyValue(from: text))
        XCTAssertEqual(value, 1234.56, accuracy: 0.001)
    }

    func testReturnsNilWhenValueIsMissing() {
        let text = "8,3 km\n17 min"
        let offer = OfferTextParser.parse(rawText: text)
        XCTAssertNil(offer)
    }

    func testReturnsNilWhenDistanceIsMissing() {
        let text = "R$ 18,50\n17 min"
        let offer = OfferTextParser.parse(rawText: text)
        XCTAssertNil(offer)
    }

    func testReturnsNilWhenNoTimeFound() {
        let text = "R$ 18,50\n8,3 km"
        let offer = OfferTextParser.parse(rawText: text)
        XCTAssertNil(offer)
    }
}
