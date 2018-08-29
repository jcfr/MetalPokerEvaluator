import Foundation

public typealias HandScore = UInt64

// 64 bits
// ................ ............RRRR ...AKQJT98765432 ...akqjt98765432
//                         hand rank       value bits      kicker bits
//
// Score is for a 5 card hand.
// High card, all value bits, no kicker bits.
// One pair, pair is 1 value bit, 3 kicker bits.
// Two pair, pairs are 2 value bits, 1 kicker bit.
// Three of a kind, triple is 1 value bit, 2 kicker bits.
// Straight, high straight card is value bit, no kicker bit.
// Flush, 5 value bits, no kicker bits.
// Full house, triple is 1 value bit, pair is 1 kicker bit.
// Four of a kind, quad is 1 value bit, 1 kicker bit.
// Straight flush, high straight flush card is value bit, no kicker bits.
//
// Hands with less than 5 cards can be evaluated.
// No straights or flushes.
// Score results in fewer kicker bits.
//
// Hands with more than 7 cards will result in errors

extension HandScore {
    
    // hand ranks
    static let
    HIGH_CARD       : HandScore = 0,
    ONE_PAIR        : HandScore = 0x100000000,
    TWO_PAIR        : HandScore = 0x200000000,
    THREE_OF_A_KIND : HandScore = 0x300000000,
    STRAIGHT        : HandScore = 0x400000000,
    FLUSH           : HandScore = 0x500000000,
    FULL_HOUSE      : HandScore = 0x600000000,
    FOUR_OF_A_KIND  : HandScore = 0x700000000,
    STRAIGHT_FLUSH  : HandScore = 0x800000000

}
