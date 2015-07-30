import SpriteKit

class Dealer: SKNode {
    var hand: Hand? = nil
    
    func addHand (hand: Hand) {
        self.hand = hand
        self.addChild(hand)
    }
}