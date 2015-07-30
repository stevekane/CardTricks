import Foundation

enum Rank: Int {
    case Ace = 0
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Ten
    case Jack
    case Queen
    case King
    
    static func Random () -> Rank {
        return Rank(rawValue: Int(arc4random_uniform(12)))!
    }
}