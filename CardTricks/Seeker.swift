import Foundation
import SpriteKit

protocol Seeker {
    var target: Target? { get set }
    func moveToTarget (duration: NSTimeInterval) -> SKAction?
}