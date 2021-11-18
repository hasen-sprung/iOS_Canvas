//
//  ListTableViewController.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/17.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    private let backButtonIcon = UIImageView()
    
    private var recordsByDate: [Record]?
    private var dateSections = [String]()
    private var sectionsCount = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        listTableView.dataSource = self
        listTableView.delegate = self
        setListTableView()
        setSectionAndRecords()
        setBackButton()
    }
    
    @objc func backButtonPressed() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "mainViewController") as? MainViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
    }
    
    private func setSectionAndRecords() {
        var rawRecords: [Record]?
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = Record.fetchRequest()
            do { rawRecords = try context.fetch(request) } catch { print("context Error") }
            rawRecords?.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            setDateSections(sortedRecords: rawRecords ?? [Record]())
        }
    }
    
    private func setDateSections(sortedRecords: [Record]) {
        for r in sortedRecords {
            let date = r.createdDate ?? Date()
            let dateString = getDateString(date: date)
            
            if let _ = dateSections.firstIndex(of: dateString) {
                sectionsCount[sectionsCount.count - 1] += 1
            } else {
                dateSections.append(dateString)
                sectionsCount.append(1)
            }
        }
    }
    
    private func getDateString(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "M/d"
        df.locale = Locale(identifier:"ko_KR")
        let dateString = df.string(from: date)
        return dateString + " " + date.dayOfWeek
    }
}

extension ListTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionsCount[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        return cell
    }
}

// MARK: - Set List Table View
extension ListTableViewController {
    private func setListTableView() {
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(nibName, forCellReuseIdentifier: "listTableViewCell")
        listTableView.rowHeight  = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 80
        setListTableViwConstraints()
        listTableView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        view.addSubview(listTableView)
    }
    
    private func setListTableViwConstraints() {
        listTableView.frame.size = CGSize(width: view.frame.width,
                                          height: view.frame.height * 0.7)
        listTableView.frame.origin = CGPoint(x: .zero,
                                             y: view.frame.height / 6 + 3)
    }
}

// MARK: - set back button constraint and UI / set seperate line
extension ListTableViewController {
    
    private func setBackButton() {
        setBackButtonConstraints()
        setBackButtonUI()
        setSeperateLine()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func setBackButtonConstraints() {
        backButton.frame.size = CGSize(width: view.frame.width / 10,
                                       height: view.frame.width / 10)
        backButton.center = CGPoint(x: view.frame.width * 7 / 8,
                                    y: view.frame.height * 0.11)
        backButtonIcon.frame.size = CGSize(width: backButton.frame.width * 3 / 6,
                                           height: backButton.frame.width * 3 / 6)
        backButtonIcon.center = backButton.center
    }
    
    private func setBackButtonUI() {
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        backButtonIcon.image = UIImage(systemName: "arrow.forward")
        backButtonIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        backButtonIcon.isUserInteractionEnabled = false
        view.addSubview(backButtonIcon)
    }
    
    private func setSeperateLine() {
        let seperateUpperView = UIView()
        let seperateUnderView = UIView()
        
        seperateUpperView.frame.size = CGSize(width: view.frame.width,
                                              height: 1)
        seperateUnderView.frame.size = seperateUpperView.frame.size
        seperateUpperView.backgroundColor = .white
        seperateUnderView.backgroundColor = UIColor(r: 195, g: 201, b: 205)
        seperateUpperView.center = CGPoint(x: view.frame.width / 2,
                                           y: view.frame.height / 6)
        seperateUnderView.center = CGPoint(x: view.frame.width / 2,
                                           y: view.frame.height / 6 + 1)
        view.addSubview(seperateUpperView)
        view.addSubview(seperateUnderView)
    }
}

extension Date {
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self)
    }
}
