import XCTest
@testable import MetalPokerEvaluator

class MetalPokerEvaluatorTests: XCTestCase {
    
    var evaluator: MetalPokerEvaluator!
    
    override func setUp() {
        super.setUp()
        evaluator = MetalPokerEvaluator()
    }
    
    override func tearDown() {
        evaluator = nil
        super.tearDown()
    }
    
    func testCanInitialize() {
        XCTAssertNotNil(evaluator)
    }
    
    func test5CardHandRankCounts() {
        let scores = evaluator.score(hands: all5CardHands)
        let rankCounts = countRanks(scores: scores)
        XCTAssertEqual(rankCounts, correct5CardRankCounts)
    }
    
    func test5CardHandRankPerformance() {
        measure {
            let _ = evaluator.score(hands: all5CardHands)
        }
    }
    
}
