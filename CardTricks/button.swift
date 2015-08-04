import Foundation
import SpriteKit

class Button: SKSpriteNode {
    static let defaultPressedTexture: SKTexture? = SKTexture(imageNamed: "grey_button02")
    static let defaultRestTexture: SKTexture? = SKTexture(imageNamed: "grey_button01")
    static let defaultPressTime: NSTimeInterval = 0.2
    static let defaultOnPress = { () -> Void in }
    
    let pressedTexture: SKTexture? = Button.defaultPressedTexture
    let restTexture: SKTexture? = Button.defaultRestTexture

    var pressed: Bool = false
    var onPress: () -> Void
    
    func press () {
        self.pressed = true
        self.texture = pressedTexture
    }
    
    func unpress () {
        self.pressed = false
        self.texture = restTexture
        self.onPress()
    }
    
    init (pressedTexture: SKTexture?, restTexture: SKTexture?, label: SKLabelNode, size: CGSize, pressed: Bool, onPress: () -> Void) {
        self.onPress = onPress
        super.init(texture: restTexture, color: UIColor.yellowColor(), size: size)
        
        label.position.y = size.height / 2 - label.fontSize
        self.userInteractionEnabled = true
        self.addChild(label)
    }
    
    convenience init (label: SKLabelNode, size: CGSize, onPress: () -> Void) {
        self.init(pressedTexture: Button.defaultPressedTexture,
                  restTexture: Button.defaultRestTexture,
                  label: label,
                  size: size,
                  pressed:true,
                  onPress: onPress)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.press()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.unpress()
    }
}