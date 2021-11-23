//
//  RecordTableView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/12.
//

import UIKit
import Macaw

class RecordTableView: UITableView {
    
    override func reloadData() {
        super.reloadData()
    }
    
    func setCellConfig() {
        self.backgroundColor = .clear
        let nibName = UINib(nibName: "RecordTableViewCell", bundle: nil)
        self.register(nibName, forCellReuseIdentifier: "RecordTableViewCell")
        self.estimatedRowHeight = 200.0
        self.rowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
    }
    
    
    func removeAllSubviewAndReload() {
        
        for section in 0 ..< self.numberOfSections {
            for row in 0 ..< self.numberOfRows(inSection: section) {
                
                if let cell = self.cellForRow(at: IndexPath(row: row, section: section)) as? RecordTableViewCell {
                    
                    cell.svgView.removeFromSuperview()
                }
            }
        }
    }
}
