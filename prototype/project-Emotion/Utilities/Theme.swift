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
            return DefaultTheme.shared
        case 1:
            return CellTheme.shared
        case 2:
            return TestTheme.shared
        default:
            return DefaultTheme.shared
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
            return getColorToInt(color: top, secondColor: mid, figure: figure)
        } else {
            return getColorToInt(color: mid, secondColor: bot, figure: figure)
        }
    }
    
    internal func getColorToInt(color: UIColor, secondColor: UIColor, figure: Float) -> Int {
        let color = color.toColor(secondColor, percentage: CGFloat(figure / 2) * 100)
        let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
        return Int(value)
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

class DefaultTheme: Theme, ThemeProtocol  {
    static let shared = DefaultTheme()
    
    private override init() {
        super.init()
        setColor()
    }
    
    internal func setColor() {
        let gaugeColor = GaugeColor(top: cellGVTop, middle: cellGVMiddle, bottom: cellGVBottom)
        let viewColor = ViewColor(main: .black, gauge: cellGV)
        let shapeColor = ShapeColor(heart: defaultRed, circle: defaultYellow, triangle: defaultGreen, rectangle: defaultBlue, line: defaultPurple)
        color = Colors(gauge: gaugeColor, view: viewColor, shape: shapeColor)
    }
    
    override func instanceSVGImages() -> [Node] {
        do {
            let nodeGroup = try SVGParser.parse(resource: "defaultImages") as! Group
            var svgNodes = [Node]()
            
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_1") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_2") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_3") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_4") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_5") ?? Node())
            return svgNodes
        } catch {
            print("svg parsing error _ ", error)
            return [Node]()
        }
    }
    
    override func getCurrentColor(figure: Float) -> Int {
        if let heart = color.shape?.heart,
           let circle = color.shape?.circle,
           let triangle = color.shape?.triangle,
           let rectangle = color.shape?.rectangle,
           let line = color.shape?.line {
            switch figure {
            case 0.0...0.2:
                return getColorToInt(color: heart, secondColor: heart, figure: figure)
            case ...0.4:
                return getColorToInt(color: circle, secondColor: circle, figure: figure)
            case ...0.6:
                return getColorToInt(color: triangle, secondColor: triangle, figure: figure)
            case ...0.8:
                return getColorToInt(color: rectangle, secondColor: rectangle, figure: figure)
            default:
                return getColorToInt(color: line, secondColor: line, figure: figure)
            }
        } else {
            return 0
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
        let shapeColor = ShapeColor(heart: defaultRed, circle: defaultYellow, triangle: defaultGreen, rectangle: defaultBlue, line: defaultPurple)
        color = Colors(gauge: gaugeColor, view: viewColor, shape: shapeColor)
    }
    
    override func instanceSVGImages() -> [Node] {
        do {
            let nodeGroup = try SVGParser.parse(resource: "cellImages") as! Group
            var svgNodes = [Node]()
            
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_1") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_2") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_3") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_4") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_5") ?? Node())
            return svgNodes
        } catch {
            print("svg parsing error _ ", error)
            return [Node]()
        }
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
        let viewColor = ViewColor(main: indigo100, gauge: pink100)
        
        color = Colors(gauge: gaugeColor, view: viewColor)
    }
    
    override func instanceSVGImages() -> [Node] {
        do {
            let nodeGroup = try SVGParser.parse(resource: "cellImages") as! Group
            var svgNodes = [Node]()
            
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_1") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_2") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_3") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_4") ?? Node())
            svgNodes.append(nodeGroup.nodeBy(tag: "svg_5") ?? Node())
            return svgNodes
        } catch {
            print("svg parsing error _ ", error)
            return [Node]()
        }
    }
}
