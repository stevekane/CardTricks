import SpriteKit

class Card: SKSpriteNode {
    var rank: Rank
    var suit: Suit
    var faceUp: Bool

    static let defaultColor: UIColor = UIColor.redColor()
    static let defaultSize: CGSize = CGSize(width: 48, height: 64)
    static let faceDownTexture: SKTexture = SKTexture(imageNamed: "cardBack_blue1")
    
    static func textureForCard (rank: Rank, suit: Suit) -> SKTexture? {
        
        var suitStr: String {
            switch suit {
            case .Diamonds: return "Diamonds"
            case .Hearts:   return "Hearts"
            case .Clubs:    return "Clubs"
            case .Spades:   return "Spades"
            }
        }
        
        var rankStr: String {
            switch rank {
            case .Ace:      return "A"
            case .Two:      return "2"
            case .Three:    return "3"
            case .Four:     return "4"
            case .Five:     return "5"
            case .Six:      return "6"
            case .Seven:    return "7"
            case .Eight:    return "8"
            case .Nine:     return "9"
            case .Ten:      return "10"
            case .Jack:     return "J"
            case .Queen:    return "Q"
            case .King:     return "K"
            }
        }
        return SKTexture(imageNamed: "card\(suitStr)\(rankStr)")
    }
    
    static func Random (faceUp faceUp: Bool) -> Card {
        return Card(rank: Rank.Random(), suit: Suit.Random(), faceUp: faceUp)
    }
    
    init (rank: Rank, suit: Suit, faceUp: Bool) {
        let texture = faceUp ? Card.textureForCard(rank, suit: suit) : Card.faceDownTexture
        
        self.rank = rank
        self.suit = suit
        self.faceUp = faceUp
        super.init(texture: texture, color: Card.defaultColor, size: Card.defaultSize)
        self.zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}