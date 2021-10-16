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
        self.rowHeight = self.frame.height * 0.5
        let nibName = UINib(nibName: "RecordTableViewCell", bundle: nil)
        self.register(nibName, forCellReuseIdentifier: "RecordTableViewCell")
    }
}
