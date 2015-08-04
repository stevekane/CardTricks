import Foundation
import SpriteKit

class Player: SKNode {
    var hands: [Hand] = []
    
    func addHand (hand: Hand) {
        self.hands.append(hand)
        self.addChild(hand)
    }
    
    func removeHand (hand: Hand) {
        if let index = self.hands.indexOf(hand) {
            self.hands.removeAtIndex(index)
            hand.removeFromParent()
        }
    }
}