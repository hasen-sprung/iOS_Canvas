
import UIKit
import Macaw

@objc protocol NodeProtocol {
    
    var nodeGroup: Group { get }
    
    func setNodes()
    
    @objc optional func getNodeGroup() -> Group
    
    func getNodeByFigure(figure: Float, currentNode: Node?) -> Node?
    
    func getStartingNode() -> Node
}

class geometricFigure: NodeProtocol  {
    
    let nodeGroup = try! SVGParser.parse(path: "emotions") as! Group
    private var svgNodes = [Node]()
    
    
    func setNodes() {
        
        svgNodes.append(self.nodeGroup.nodeBy(tag: "svg_1")!)
        svgNodes.append(self.nodeGroup.nodeBy(tag: "svg_2")!)
        svgNodes.append(self.nodeGroup.nodeBy(tag: "svg_3")!)
        svgNodes.append(self.nodeGroup.nodeBy(tag: "svg_4")!)
        svgNodes.append(self.nodeGroup.nodeBy(tag: "svg_5")!)
    }
    
    func getNodeByFigure(figure: Float, currentNode: Node?) -> Node? {
        
        if let oldNode = currentNode {
            
            if figure <= 0.36 {
                if  oldNode != self.svgNodes[0] {
                    return self.svgNodes[0]
                } else {
                    return nil
                }
            } else if figure > 0.36 && figure <= 0.52 {
                if  oldNode != self.svgNodes[1] {
                    return self.svgNodes[1]
                } else {
                    return nil
                }
            } else if figure > 0.52 && figure <= 0.68 {
                if  oldNode != self.svgNodes[2] {
                    return self.svgNodes[2]
                } else {
                    return nil
                }
            } else if figure > 0.68 && figure <= 0.84 {
                if  oldNode != self.svgNodes[3] {
                    return self.svgNodes[3]
                } else {
                    return nil
                }
            } else {
                if  oldNode != self.svgNodes[4] {
                    return self.svgNodes[4]
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    
    func getStartingNode() -> Node {
        
        return self.svgNodes[2]
    }
}
