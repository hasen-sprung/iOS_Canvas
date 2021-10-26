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
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 밀어서 뒤로가기 기능 제거
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
        view.addSubview(recordTableView)
    }
    
    @objc func swipeScreen() {
        
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
        recordTableView.reloadData()
    }
    
    @objc func handleSwipeLeftGesture(recognizer: UISwipeGestureRecognizer) {
        print("This swipe is forward")
        dateManager.changeDate(val: 1)
        dateNavigationView.setLabelText()
        currentRecords = recordManager.getMatchingRecords()
        recordTableView.reloadData()
    }
}
