//
//  ArchiveViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/25.
//

import UIKit

class ArchiveViewController: UIViewController {

    private let recordTableView = RecordTableView()
    private var currentRecords: [Record] = [Record]()
    private let dateManager = DateManager.shared
    private let recordManager = RecordManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordTableView.dataSource = self
        recordTableView.delegate = self
        setRecordTableView()
        
        currentRecords = recordManager.getMatchingRecords()
        
        view.addSubview(recordTableView)
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setRecordTableView() {
        
        recordTableView.rowHeight = UITableView.automaticDimension
        recordTableView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.6)
        recordTableView.frame.origin = CGPoint(x: 0, y: view.frame.height * 0.25)
        recordTableView.backgroundColor = .clear
        recordTableView.setCellConfig()
        view.addSubview(recordTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        
        cell.setCellContents(records: currentRecords, indexPath: indexPath)
        
        return cell
    }
}
