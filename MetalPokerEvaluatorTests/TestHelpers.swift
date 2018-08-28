@testable import MetalPokerEvaluator

let all5CardHands: [CardMask] = {
    let cards = CardMask.allCards
    var hands: [CardMask] = []
    for a in 0..<48 {
        for b in a+1..<49 {
            for c in b+1..<50 {
                for d in c+1..<51 {
                    for e in d+1..<52 {
                        hands.append(
                            cards[a] | cards[b] | cards[c] | cards[d] | cards[e]
                        )
                    }
                }
            }
        }
    }
    return hands
}()

func countRanks(scores: [HandScore]) -> [Int] {
    var counts = Array<Int>(repeating: 0, count: 9)
    var rankErrorCount = 0
    for score in scores {
        let rank = Int(score >> 32)
        if rank < counts.count {
            counts[Int(score >> 32)] += 1
        } else {
            rankErrorCount += 1
        }
    }
    if rankErrorCount > 0 { print("Rank errors: \(rankErrorCount)") }
    return counts
}

let correct5CardRankCounts = [
    1302540, // high card
    1098240, // one pair
    123552,  // two pair
    54912,   // three of a kind
    10200,   // straight
    5108,    // flush
    3744,    // full house
    624,     // four of a kind
    40       // straight flush
]

let correct7CardRankCounts = [
    23294460, // high card
    58627800, // one pair
    31433400, // two pair
    6461620,  // three of a kind
    6180020,  // straight
    4047644,  // flush
    3473184,  // full house
    224848,   // four of a kind
    41584     // striaght flush
]
