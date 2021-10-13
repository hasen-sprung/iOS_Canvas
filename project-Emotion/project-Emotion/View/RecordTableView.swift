//
//  RecordTableView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/12.
//

import UIKit

class RecordTableView: UITableView {
    
    var records: [Record] = [Record]()
    
    func setRecordsIntoTableView(_ newRecords: [Record] = [Record]()) {
        
        self.records = newRecords
        register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.reloadData()
    }
    
}
