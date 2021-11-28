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
}

struct RecordViewRatio {
    var tempRatio: CGFloat = 0.125
    
    // MARK: - records.count에 따라 도형의 비율을 크게 or 작게
    var ratio: CGFloat {
        get {
            return tempRatio
        }
        set(count) {
            switch count {
            case 1...2:
                tempRatio = 0.145
            case 3...4:
                tempRatio = 0.140
            case 5...6:
                tempRatio = 0.135
            case 7...8:
                tempRatio = 0.130
            default:
                tempRatio = 0.125
            }
        }
    }
}
