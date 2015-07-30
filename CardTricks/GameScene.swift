import Foundation
import SpriteKit

class GameScene: SKScene {
    var bg: SKSpriteNode?
    var fg: SKNode?
    var deckSpawn: SKNode?
    var dealerSpawn: SKNode?
    var dealer: Dealer?
    var playerSpawns: [SKNode]? = []
    var players: [Player] = []
    
    static let dealDuration: NSTimeInterval = 4.0
    
    override func didMoveToView(view: SKView) {
        self.bg = self.childNodeWithName("background") as! SKSpriteNode?
        self.fg = self.childNodeWithName("foreground")
        self.deckSpawn = fg?.childNodeWithName("deckSpawn")
        self.dealerSpawn = fg?.childNodeWithName("dealerSpawn")
        
        if let fg = self.fg {
            fg.enumerateChildNodesWithName("playerSpawn") {
                playerSpawn, _ in
                self.addPlayer(playerSpawn, layer: fg, player: Player())
            }
            
            if let dealerSpawn = self.dealerSpawn {
                self.addDealer(dealerSpawn, layer: fg, dealer: Dealer())
            }
        }

        if let deckSpawn = self.deckSpawn {
            self.runAction(self.dealRound(deckSpawn, rounds: 5)) {
                print("The dealing is over Jim")
            }
        }
    }
    
    func addDealer (dealerSpawn: SKNode, layer: SKNode, dealer: Dealer) {
        dealer.position = dealerSpawn.position
        self.dealer = dealer
        layer.addChild(dealer)
    }
    
    func addPlayer (playerSpawn: SKNode, layer: SKNode, player: Player) {
        player.position = playerSpawn.position
        self.players.append(player)
        layer.addChild(player)
    }
    
    func dealCard (from: SKNode, hand: Hand, card: Card) -> SKAction {
        let duration = 0.3
        let halfDuration = duration / 2
        let locationInHandCoords = from.convertPoint(from.position, toNode: hand)
        
        let growAndShrink = SKAction.sequence([
            SKAction.scaleTo(2.4, duration: halfDuration),
            SKAction.scaleTo(1.0, duration: halfDuration)
        ])

        let animation = SKAction.group([
            card.moveToTarget(duration)!,
            growAndShrink,
            SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: duration),
            SKAction.playSoundFileNamed("cardSlide5", waitForCompletion: false)
        ])
        
        card.position = locationInHandCoords
        hand.addCard(card)
        
        return animation
    }
    
    func dealRound (from: SKNode, rounds: Int) -> SKAction {
        guard rounds > 0 else { return SKAction.waitForDuration(0) }
        
        var dealSequence: [SKAction] = []
        var roundCount = 0
        
        for player in self.players {
            player.removeAllChildren() //TODO: this should only remove the hands...
            player.addHand(Hand())
        }
        
        repeat {
            for player in self.players {
                for hand in player.hands {
                    let card = Card(faceUp: true, target: hand)
                   
                    dealSequence.append(SKAction.runBlock({ card.runAction(self.dealCard(from, hand: hand, card: card)) }))
                    dealSequence.append(SKAction.waitForDuration(0.1))
                }
            }
        } while ( ++roundCount < rounds )
        
        //TODO: adding final delay here as buffer before starting action
        dealSequence.append(SKAction.waitForDuration(1.0))
        
        return SKAction.sequence(dealSequence)
    }
}