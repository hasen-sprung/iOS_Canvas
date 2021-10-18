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
    
    override func reloadData() {
        super.reloadData()
    }
    
    func setCellConfig() {
        
        let nibName = UINib(nibName: "RecordTableViewCell", bundle: nil)
        self.register(nibName, forCellReuseIdentifier: "RecordTableViewCell")
        self.estimatedRowHeight = 200.0
        self.rowHeight = UITableView.automaticDimension

    }
}
