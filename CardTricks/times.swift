import Foundation

extension Int {
    func times (block: (count: Int) -> ()) -> Void {
        var count = 0
        
        repeat { block(count: count) } while (++count < self)
    }
}