import Foundation
import SpriteKit

class Player: SKNode {
    var hands: [Hand] = []
    
    func addHand (hand: Hand) {
        self.hands.append(hand)
        self.addChild(hand)
    }
}