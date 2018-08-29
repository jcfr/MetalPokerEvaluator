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
    
    func test5CardPerformance() {
        measure {
            let _ = evaluator.score(hands: all5CardHands)
        }
    }

    func test5CardPerformanceMakeHandsBuffer() {
        measure {
            let _ = evaluator.makeHandsBuffer(hands: all5CardHands)
        }
    }

    func test5CardPerformanceMakeScoresBuffer() {
        measure {
            let _ = evaluator.makeScoreBuffer(count: all5CardHands.count)
        }
    }

    func test5CardPerformanceDispatch() {
        let handsBuffer = evaluator.makeHandsBuffer(hands: all5CardHands)!
        let scoresBuffer = evaluator.makeScoreBuffer(count: all5CardHands.count)!
        measure {
            let _ = evaluator.dispatchScoreCommand(
                handsBuffer: handsBuffer,
                scoresBuffer: scoresBuffer,
                count: all5CardHands.count
            )
        }
    }

    func test5CardPerformanceWait() {
        let handsBuffer = evaluator.makeHandsBuffer(hands: all5CardHands)!
        let scoresBuffer = evaluator.makeScoreBuffer(count: all5CardHands.count)!
        let commandBuffer = evaluator.dispatchScoreCommand(
            handsBuffer: handsBuffer,
            scoresBuffer: scoresBuffer,
            count: all5CardHands.count
        )!
        measure {
            commandBuffer.waitUntilCompleted()
        }
    }

    func test5CardPerformanceMakeScoresArray() {
        let handsBuffer = evaluator.makeHandsBuffer(hands: all5CardHands)!
        let scoresBuffer = evaluator.makeScoreBuffer(count: all5CardHands.count)!
        let commandBuffer = evaluator.dispatchScoreCommand(
            handsBuffer: handsBuffer,
            scoresBuffer: scoresBuffer,
            count: all5CardHands.count
            )!
        commandBuffer.waitUntilCompleted()
        measure {
            let _ = evaluator.makeScoresArray(
                scoresBuffer: scoresBuffer,
                count: all5CardHands.count
            )
        }
    }

}
