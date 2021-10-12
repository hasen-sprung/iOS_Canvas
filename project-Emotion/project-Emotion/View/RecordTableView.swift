//
//  RecordTableView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/12.
//

import UIKit

class RecordTableView: UITableView, UITableViewDelegate {
    
    var records: [Record] = [Record]()
    
    func setRecordsIntoTableView(_ newRecords: [Record] = [Record]()) {
        
        self.records = newRecords
        register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    private func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell (withIdentifier: "TableViewCell")!
        
        cell.textLabel?.text = records[indexPath.row].memo
        
        return cell
    }
    
}
