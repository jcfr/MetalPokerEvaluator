import Foundation

typealias CardMask = UInt64

// 4 x 16-bit words
// ...AKQJT98765432 ...AKQJT98765432 ...AKQJT98765432 ...AKQJT98765432
//           spades           hearts         diamonds            clubs

extension CardMask {
    
    static let
    TWOS    : CardMask = 0x0001000100010001,
    THREES  : CardMask = 0x0002000200020002,
    FOURS   : CardMask = 0x0004000400040004,
    FIVES   : CardMask = 0x0008000800080008,
    SIXES   : CardMask = 0x0010001000100010,
    SEVENS  : CardMask = 0x0020002000200020,
    EIGHTS  : CardMask = 0x0040004000400040,
    NINES   : CardMask = 0x0080008000800080,
    TENS    : CardMask = 0x0100010001000100,
    JACKS   : CardMask = 0x0200020002000200,
    QUEENS  : CardMask = 0x0400040004000400,
    KINGS   : CardMask = 0x0800080008000800,
    ACES    : CardMask = 0x1000100010001000,
    SPADES  : CardMask = 0x0000000000001FFF,
    HEARTS  : CardMask = 0x000000001FFF0000,
    DIAMONDS: CardMask = 0x00001FFF00000000,
    CLUBS   : CardMask = 0x1FFF000000000000,
    DECK    : CardMask = 0x1FFF1FFF1FFF1FFF
    
    static let
    allSuits: [CardMask] = [SPADES,HEARTS,DIAMONDS,CLUBS],
    allRanks: [CardMask] = [TWOS,THREES,FOURS,FIVES,SIXES,SEVENS,EIGHTS,NINES,
                            TENS,JACKS,QUEENS,KINGS,ACES],
    allCards: [CardMask] = {
        var cards = [CardMask]()
        cards.reserveCapacity(52)
        for suit in allSuits {
            for rank in allRanks {
                cards.append(rank & suit)
            }
        }
        return cards
    }()
    
    init?(cardString: String) {
        let characters = cardString.map { $0 } .filter { $0 != " " }
        guard characters.count % 2 == 0 else {
            print("CardMask cannot be initialized with \"\(cardString)\".\nString must have an even number of non-space characters.")
            return nil
        }
        let characterPairs = stride(from: 0, to: characters.count - 1, by: 2)
            .map { (characters[$0], characters[$0 + 1]) }
        var hand: CardMask = 0
        for (rankCharacter, suitCharacter) in characterPairs {
            let rank: CardMask
            switch rankCharacter {
                case "2"      : rank = CardMask.TWOS
                case "3"      : rank = CardMask.THREES
                case "4"      : rank = CardMask.FOURS
                case "5"      : rank = CardMask.FIVES
                case "6"      : rank = CardMask.SIXES
                case "7"      : rank = CardMask.SEVENS
                case "8"      : rank = CardMask.EIGHTS
                case "9"      : rank = CardMask.NINES
                case "T", "t" : rank = CardMask.TENS
                case "J", "j" : rank = CardMask.JACKS
                case "Q", "q" : rank = CardMask.QUEENS
                case "K", "k" : rank = CardMask.KINGS
                case "A", "a" : rank = CardMask.ACES
                default       : rank = 0
            }
            let suit: CardMask
            switch suitCharacter {
                case "c", "C" : suit = CardMask.CLUBS
                case "d", "D" : suit = CardMask.DIAMONDS
                case "h", "H" : suit = CardMask.HEARTS
                case "s", "S" : suit = CardMask.SPADES
                default       : suit = 0
            }
            if rank == 0 || suit == 0 {
                print("CardMask cannot be initialized with \"\(cardString)\".\n\"\(rankCharacter)\(suitCharacter)\" is not a valid card.")
                return nil
            }
            hand |= (rank & suit)
        }
        self = hand
    }
}
