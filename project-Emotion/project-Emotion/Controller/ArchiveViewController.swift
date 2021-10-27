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
    private var countRecordsByDate: [DateCount]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 밀어서 뒤로가기 기능 제거
        view.backgroundColor = .white
        recordTableView.dataSource = self
        recordTableView.delegate = self
        dateNavigationView.delegate = self
        setRecordTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateManager.setCurrentDateForNow()
        dateNavigationView.setDateNavigationLayout()
        currentRecords = recordManager.getMatchingRecords()
        setSwipeActions()
        countRecordsByDate = recordManager.getDateList(currentRecords: currentRecords)
        view.addSubview(recordTableView)
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setRecordTableView() {
        
        recordTableView.rowHeight = UITableView.automaticDimension
        recordTableView.backgroundColor = .clear
        recordTableView.setCellConfig()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let countRecordsByDate = recordManager.getDateList(currentRecords: currentRecords)
        
        return countRecordsByDate.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return countRecordsByDate?[section].getDate() ?? "error"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countRecordsByDate?[section].getCount() ?? 0
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
        countRecordsByDate = recordManager.getDateList(currentRecords: currentRecords)
        recordTableView.reloadData()
    }
}

extension ArchiveViewController {
    
    private func setSwipeActions() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(handleSwipeRightGesture))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftGesture))
        swipeLeft.direction = .left
        
        recordTableView.addGestureRecognizer(swipeRight)
        recordTableView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeRightGesture(recognizer: UISwipeGestureRecognizer) {
        print("This swipe is backward")
        dateManager.changeDate(val: -1)
        dateNavigationView.setLabelText()
        currentRecords = recordManager.getMatchingRecords()
        countRecordsByDate = recordManager.getDateList(currentRecords: currentRecords)
        recordTableView.reloadData()
    }
    
    @objc func handleSwipeLeftGesture(recognizer: UISwipeGestureRecognizer) {
        print("This swipe is forward")
        dateManager.changeDate(val: 1)
        dateNavigationView.setLabelText()
        currentRecords = recordManager.getMatchingRecords()
        countRecordsByDate = recordManager.getDateList(currentRecords: currentRecords)
        recordTableView.reloadData()
    }
}
