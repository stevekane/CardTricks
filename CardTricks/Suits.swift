import Foundation

enum Suit: Int {
    case Diamonds = 0
    case Hearts
    case Spades
    case Clubs
    
    static func Random () -> Suit {
        return Suit(rawValue: Int(arc4random_uniform(3)))!
    }
}