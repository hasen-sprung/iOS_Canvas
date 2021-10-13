//
//  RecordTableView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/12.
//

import UIKit
import Macaw

class RecordTableView: UITableView {
    
    let theme = ThemeManager.shared.getThemeInstance()
    var records: [Record] = [Record]()
    
    
    
    func setRecordsIntoTableView(_ newRecords: [Record] = [Record]()) {
        
        self.records = newRecords
        register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.reloadData()
    }
    
    
    func makeDayCell(_ tableView: UITableView, _ indexPath: IndexPath, _ currentRecords: [Record]) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        let svgImages = theme.instanceSVGImages()
        
        let recordSVGView = SVGView(frame: CGRect(x: cell.frame.width * 0.1,
                                                  y: 0,
                                                  width: cell.frame.height,
                                                  height: cell.frame.height))
        let recordTimeLabel = UILabel(frame: CGRect(x: cell.frame.width * 0.3,
                                                    y: 0,
                                                    width: cell.frame.width * 0.3,
                                                    height: cell.frame.height))
        
        let recordMemoLabel = UILabel(frame: CGRect(x: cell.frame.width * 0.6,
                                                    y: 0,
                                                    width: cell.frame.width * 0.4,
                                                    height: cell.frame.height))
        
        let gauge = currentRecords[indexPath.row].gaugeLevel
        let time = currentRecords[indexPath.row].createdDate
        let memo = currentRecords[indexPath.row].memo
        
        let df = DateFormatter()
        df.dateFormat = "a h:mm"
        df.locale = Locale(identifier:"ko_KR")
        let timeString = df.string(from: time!)
        
        recordTimeLabel.text = timeString
        recordTimeLabel.textAlignment = .left
        recordTimeLabel.backgroundColor = .clear
        recordTimeLabel.textColor = .black
        
        recordSVGView.backgroundColor = .clear
        recordSVGView.node = theme.getNodeByFigure(figure: gauge, currentNode: nil, svgNodes: svgImages) ?? Node()
        let svgShape = (recordSVGView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(CellTheme.shared.getCurrentColor(figure: gauge))
        
        recordMemoLabel.text = memo
        recordMemoLabel.textColor = .black
        recordMemoLabel.backgroundColor = .clear
        recordMemoLabel.textAlignment = .left
        
        cell.backgroundColor = .clear
        cell.contentView.addSubview(recordSVGView)
        cell.contentView.addSubview(recordTimeLabel)
        cell.contentView.addSubview(recordMemoLabel)
        
        return cell
    }
    
    func removeAllSubviewAndReload() {
        
        for section in 0 ..< self.numberOfSections {
            for row in 0 ..< self.numberOfRows(inSection: section) {
                
                if let cell = self.cellForRow(at: IndexPath(row: row, section: section)) {
                    
                    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                }
            }
        }
        
        self.reloadData()
    }
}
