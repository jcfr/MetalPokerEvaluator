import XCTest
@testable import MetalPokerEvaluator

class CardMaskTests: XCTestCase {
    
    func testStaticConstantCounts() {
        XCTAssertEqual(
            CardMask.allRanks.count,
            13,
            "Should have 13 ranks."
        )
        XCTAssertEqual(
            CardMask.allSuits.count,
            4,
            "Should have 4 suits."
        )
        XCTAssertEqual(
            CardMask.allCards.count,
            52,
            "Should have 52 cards."
        )
    }
    
    func testStringInit() {
        XCTAssertEqual(
            CardMask(cardString: ""),
            0,
            "Empty string should init."
        )
        XCTAssertEqual(
            CardMask(cardString: "Kh7d"),
            (CardMask.KINGS & CardMask.HEARTS)
                | (CardMask.SEVENS & CardMask.DIAMONDS),
            "Good cards should init."
        )
        XCTAssertEqual(
            CardMask(cardString: " Kh 7d  "),
            (CardMask.KINGS & CardMask.HEARTS)
                | (CardMask.SEVENS & CardMask.DIAMONDS),
            "Should ignore spaces."
        )
        XCTAssertNil(
            CardMask(cardString: "Kh7d8"),
            "Uneven string should fail."
        )
        XCTAssertNil(
            CardMask(cardString: "Kh0d"),
            "Bad rank should fail."
        )
        XCTAssertNil(
            CardMask(cardString: "Kh7y"),
            "Bad suit should fail."
        )
    }
}
