import Foundation
import UIKit

struct Ratio {
    var x: Float
    var y: Float
    
    init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}

extension Ratio {
    static let DefaultRatio: [Ratio] = [
        Ratio(0.49264434, 0.70139617),
        Ratio(0.21994233, 0.81064165),
        Ratio(0.8282387, 0.19171816),
        Ratio(0.8136161, 0.34084213),
        Ratio(0.86889786, 0.52342755),
        Ratio(0.7128942, 0.8583792),
        Ratio(0.40130216, 0.48571178),
        Ratio(0.2254144, 0.5503703),
        Ratio(0.27573407, 0.35549185),
        Ratio(0.46675786, 0.8389069)
    ]
    
    static func printRatio() {
        let context = CoreDataStack.shared.managedObjectContext
        let request = Position.fetchRequest()
        var positions: [Position] = [Position]()
        
        do {
            positions = try context.fetch(request)
        } catch { print("context Error") }
        for p in positions {
            print("Ratio(\(p.xRatio), \(p.yRatio)),")
        }
    }
}
