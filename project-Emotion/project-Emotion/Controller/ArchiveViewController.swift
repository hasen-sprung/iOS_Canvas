//
//  ArchiveViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/25.
//

import UIKit

class ArchiveViewController: UIViewController {

    
    @IBOutlet weak var dateNavigationView: DateNavigationView!
    @IBOutlet weak var recordTableView: RecordTableView!
    
    private var currentRecords: [Record] = [Record]()
    
    private let dateManager = DateManager.shared
    private let recordManager = RecordManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordTableView.dataSource = self
        recordTableView.delegate = self
        dateNavigationView.delegate = self
        setRecordTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateManager.setCurrentDateForNow()
        dateNavigationView.setDateNavigationLayout()
        currentRecords = recordManager.getMatchingRecords()
        view.addSubview(recordTableView)
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setRecordTableView() {
        
        recordTableView.rowHeight = UITableView.automaticDimension
        recordTableView.backgroundColor = .clear
        recordTableView.setCellConfig()
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

extension ArchiveViewController: DateNavigationViewDelegate {
    
    func getDateString() -> String {
        return dateManager.getCurrentDateString()
    }
    
    
    func changeDateMode(mode: Int) {
        dateManager.setDateMode(newMode: mode)
        currentRecords = recordManager.getMatchingRecords()
        recordTableView.reloadData()
    }
}
