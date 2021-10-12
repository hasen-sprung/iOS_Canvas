
import UIKit
import Macaw

protocol ThemeProtocol {
    func setColor()
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
        case 1:
            return TestTheme.shared
        default:
            return CellTheme.shared
        }
    }
}

class Theme {
    
    internal var color: Colors!
    
    func getColor() -> Colors {
        return color
    }
    
    func instanceSVGImages() -> [Node] {
        return [Node]()
    }
    
    // MARK: - 3가지의 그라데이션 색상을 추적하는 함수, 중간(0.5)을 기준으로 각각의 비율에 맞춰서 3 색상 사이의 값을 리턴해준다.
    func getCurrentColor(figure: Float) -> Int {
        let top = color.gauge.top
        let bot = color.gauge.bottom
        let mid = color.gauge.middle
        
        if figure < 0.5 {
            let color = top.toColor(mid, percentage: CGFloat(figure * 2) * 100)
            let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
            return Int(value)
        } else {
            let color = mid.toColor(bot, percentage: CGFloat(figure / 2) * 100)
            let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
            return Int(value)
        }
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
    
    static let shared = CellTheme()
    
    private override init() {
        super.init()
        setColor()
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
    
    
}

class TestTheme: Theme, ThemeProtocol {
    static let shared = TestTheme()
    
    private override init() {
        super.init()
        setColor()
    }
    
    internal func setColor() {
        let gaugeColor = GaugeColor(top: indigo100, middle: indigo500, bottom: indigo900)
        let viewColor = ViewColor(main: red900, gauge: red500)
        
        color = Colors(gauge: gaugeColor, view: viewColor)
    }
    
    override func instanceSVGImages() -> [Node] {
        
        let nodeGroup = try! SVGParser.parse(resource: "cellImages") as! Group
        var svgNodes = [Node]()
        
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(nodeGroup.nodeBy(tag: "svg_1")!)
        
        return svgNodes
    }
    
}

