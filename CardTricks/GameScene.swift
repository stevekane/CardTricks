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
            
            /*
            if let dealer = self.dealer {
                let hand = Hand()
                let c1 = Card.Random(faceUp: false)
                let c2 = Card.Random(faceUp: true)
                
                //TODO: remove only hands soon!
                dealer.removeAllChildren()
                c1.position = hand.offset
                hand.addCard(c1)
                c2.position = hand.offset
                hand.addCard(c2)
                dealer.addHand(hand)
            }
            */
            
            repeat {
                for player in self.players {
                    for hand in player.hands {
                        let newPosition = self.convertPoint(deckPosition, toNode: hand)
                        let card = Card.Random(faceUp: true)
                        let moveToTarget = SKAction.moveTo(hand.offset, duration: dealDuration)
                        let rotate = SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: dealDuration)
                        let grow = SKAction.scaleTo(2.4, duration: halfDuration)
                        let shrink = SKAction.scaleTo(1.0, duration: halfDuration)
                        let growAndShrink = SKAction.sequence([grow, shrink])
                        let playSound = SKAction.playSoundFileNamed("cardSlide5", waitForCompletion: false)
                        let animation = SKAction.group([moveToTarget, rotate, growAndShrink, playSound])
                    
                        hand.addCard(card)
                        card.position = newPosition
                        card.runAction(SKAction.sequence([SKAction.hide(),
                                                          SKAction.waitForDuration(delay),
                                                          SKAction.unhide(),
                                                          animation]))
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