import Foundation
import SpriteKit

enum GameState {
    case Waiting
    case Dealing
    case Acting
    case Scoring
}

class BlackJackTable: SKScene {
    var state: GameState = .Waiting
    var bg: SKSpriteNode?
    var fg: SKNode?
    var ui: SKNode?
    var deckSpawn: SKNode?
    var dealerSpawn: SKNode?
    var dealer: Dealer?
    var playerSpawns: [SKNode]? = []
    var players: [Player] = []
    
    static let dealDuration: NSTimeInterval = 4.0
    
    override func didMoveToView(view: SKView) {
        self.bg = self.childNodeWithName("background") as! SKSpriteNode?
        self.fg = self.childNodeWithName("foreground")
        self.ui = self.childNodeWithName("ui")
        self.deckSpawn = fg?.childNodeWithName("deckSpawn")
        self.dealerSpawn = fg?.childNodeWithName("dealerSpawn")
  
        guard let deckSpawn = self.deckSpawn, dealerSpawn = self.dealerSpawn,
                  fg = self.fg, bg = self.bg, ui = self.ui else {
            print("missing needed stuff")
            return
        }
        
        let dealLabel = SKLabelNode(text: "Deal")
        let dealButton = Button(label: dealLabel, size: CGSize(width: 100, height: 40),
                                onPress: { () -> Void in self.dealRound(deckSpawn, rounds: 2) })
        
        
        fg.enumerateChildNodesWithName("playerSpawn") {
            playerSpawn, _ in
            self.addPlayer(playerSpawn, layer: fg, player: Player())
        }
            
        self.addDealer(dealerSpawn, layer: fg, dealer: Dealer())
        
        dealLabel.fontColor = UIColor.blackColor()
        dealLabel.fontSize = 30
        dealLabel.fontName = "Damascus"
        dealButton.position.y = -300
        ui.addChild(dealButton)
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
    
    func dealCard (from: SKNode, hand: Hand, card: Card) -> Void {
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
        
        
        hand.addCard(card)
        card.position = locationInHandCoords
        card.runAction(animation)
    }
    
    func dealRound (from: SKNode, rounds: Int) -> Void {
        guard rounds > 0 else { return }
        guard self.state == .Waiting else { return }
        
        var dealSequence: [SKAction] = []
        
        if let dealer = self.dealer {
            dealer.removeHand()
            dealer.addHand(Hand())
        }
        
        for player in self.players {
            for hand in player.hands {
                player.removeHand(hand)
            }
            player.addHand(Hand())
        }
        
        dealSequence.append(SKAction.runBlock { self.state = .Dealing })
        
        rounds.times {
            round in

            if let dealerHand = self.dealer?.hand {
                let card = Card(faceUp: round == 0 ? false : true, target: dealerHand)
                
                dealSequence.append(SKAction.runBlock({
                    self.dealCard(from, hand: dealerHand, card: card)
                }))
                dealSequence.append(SKAction.waitForDuration(0.1))
            }
            
            for player in self.players {
                for hand in player.hands {
                    let card = Card(faceUp: true, target: hand)
                    
                    dealSequence.append(SKAction.runBlock({
                        self.dealCard(from, hand: hand, card: card)
                    }))
                    dealSequence.append(SKAction.waitForDuration(0.1))
                }
            }
        }
        
        //TODO: adding final delay here as buffer before starting action
        dealSequence.append(SKAction.waitForDuration(1.0))
        dealSequence.append(SKAction.runBlock { self.state = .Waiting })
        
        self.runAction(SKAction.sequence(dealSequence))
    }
}