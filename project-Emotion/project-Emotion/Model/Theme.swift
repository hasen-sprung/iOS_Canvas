
import UIKit
import Macaw

protocol ThemeProtocol {
    func setColor()
}

class Theme {
    
    internal var color: Colors!
    
    func getColor() -> Colors {
        return color
    }
    func instanceSVGImages() -> [Node] {
        return [Node]()
    }
    
    func getNodeByFigure(figure: Float, currentNode: Node?, svgNodes: [Node]) -> Node? {
        
        if figure <= 0.2 {
            if  currentNode != svgNodes[0] {
                return svgNodes[0]
            } else {
                return nil
            }
        } else if figure <= 0.4 {
            if  currentNode != svgNodes[1] {
                return svgNodes[1]
            } else {
                return nil
            }
        } else if figure <= 0.6 {
            if  currentNode != svgNodes[2] {
                return svgNodes[2]
            } else {
                return nil
            }
        } else if figure <= 0.8 {
            if  currentNode != svgNodes[3] {
                return svgNodes[3]
            } else {
                return nil
            }
        } else {
            if  currentNode != svgNodes[4] {
                return svgNodes[4]
            } else {
                return nil
            }
        }
    }
}

class CellTheme: Theme, ThemeProtocol  {
    
//            mainViewBackground = cellMV
//            gaugeViewBackground = cellGV
//            gaugeColor = GaugeColor(top: cellGVTop, middle: cellGVMiddle, bottom: cellGVBottom)
    static let shared = CellTheme()
    
    private override init() {
        super.init()
        setColor()
        print("init singleton")
    }
    
    internal func setColor() {
        let gaugeColor = GaugeColor(top: cellGVTop, middle: cellGVMiddle, bottom: cellGVBottom)
        let viewColor = ViewColor(main: cellMV, gauge: cellGV)
        
        color = Colors(gauge: gaugeColor, view: viewColor)
    }
    
    override func instanceSVGImages() -> [Node] {
        
        let nodeGroup = try! SVGParser.parse(resource: "cellImages") as! Group
        var svgNodes = [Node]()
        
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_2")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_3")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_4")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_5")!)
        
        return svgNodes
    }
    
    func getCurrentColor(figure: Float) -> Int {
        if let top = color?.gauge.top, let bot = color?.gauge.bottom {
            let color = top.toColor(bot, percentage: CGFloat(figure) * 100)
            let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
            return Int(value)
        } else {
            return 0
        }
    }
    
}

class ThemeManager {
    
    static let shared = ThemeManager()
    private var userThemeValue = 0
    
    func setUserThemeValue(themeValue: Int) {
        userThemeValue = themeValue
    }
    
    private init() {}
    
    func getThemeInstance() -> Theme {
        switch userThemeValue {
        case 0:
            return CellTheme.shared
        default:
            return CellTheme.shared
        }
    }
}
