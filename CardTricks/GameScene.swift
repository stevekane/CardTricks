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

        self.dealRound()
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
    
    func dealRound () {
        if let deckSpawn = self.deckSpawn {
            let deckPosition = deckSpawn.position
            let dealDuration: NSTimeInterval = 0.3
            let halfDuration = dealDuration / 2
            let totalRounds = 5
            var roundCount = 0
            var delay: NSTimeInterval = 0
            
            for player in self.players {
                let hand = Hand()
                
                //TODO: remove only hands soon!
                player.removeAllChildren()
                player.addHand(hand)
            }

            repeat {
                for player in self.players {
                    for hand in player.hands {
                        let newPosition = self.convertPoint(deckPosition, toNode: hand)
                        let card = Card(faceUp: true, target: hand)
                    
                        let growAndShrink = SKAction.sequence([
                            SKAction.scaleTo(2.4, duration: halfDuration),
                            SKAction.scaleTo(1.0, duration: halfDuration)
                        ])
                        
                        let animation = SKAction.group([
                            card.moveToTarget(dealDuration)!,
                            growAndShrink,
                            SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: dealDuration),
                            SKAction.playSoundFileNamed("cardSlide5", waitForCompletion: false)
                        ])
                        
                        let dealSequence = SKAction.sequence([
                            SKAction.hide(),
                            SKAction.waitForDuration(delay),
                            SKAction.unhide(),
                            animation
                        ])
                    
                        hand.addCard(card)
                        card.position = newPosition
                        card.runAction(dealSequence)
                        delay += halfDuration
                    }
                }
            } while ( ++roundCount < totalRounds )
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}