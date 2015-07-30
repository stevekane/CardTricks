import SpriteKit

class Hand: SKNode {
    static let CARD_OFFSET: CGPoint = CGPoint(x: 14, y: 2)
    
    var currentBet: Int = 0
    var cards: [Card] = []
    var offset: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(self.cards.count) * Hand.CARD_OFFSET.x,
                y: CGFloat(self.cards.count) * Hand.CARD_OFFSET.y)
        }
    }
    
    func addCard (card: Card) {
        self.cards.append(card)
        self.addChild(card)
    }
    
    func removeCard (card: Card) {
        if let index = self.cards.indexOf(card) {
            self.cards.removeAtIndex(index)
            card.removeFromParent()
        }
    }
}