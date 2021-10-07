
import UIKit
import Macaw

protocol ThemeProtocol {

    func instanceSVGImages() -> [Node]
}

class Theme: ThemeProtocol {
    
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

class CellTheme: Theme  {
    
    static let shared = CellTheme()
    
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
        let color = ThemeManager.shared.colors.gaugeColor.top.toColor(ThemeManager.shared.colors.gaugeColor.bottom, percentage: CGFloat(figure) * 100)
        let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
        return Int(value)
    }
}
