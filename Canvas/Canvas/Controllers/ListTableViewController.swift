//
//  ListTableViewController.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/17.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var calendarView: UICollectionView!
    private var calendarDateLabel = UILabel()
    private var dateFWButton = UIButton()
    private var dateBWButton = UIButton()
    @IBOutlet weak var searchDateButton: UIButton!
    private var searchDateButtonIcon = UIImageView()
    private var searchDateButtonTag = false
    @IBOutlet weak var backButton: UIButton!
    private let backButtonIcon = UIImageView()
    private let emptyMessage = UILabel()
    
    // MARK: - record parsing properties
    private var recordsByDate = [[Record]]()
    private var dateSections = [String]()
    private var onlyDateStr = [String]()
    
    // MARK: - Calendar Creation properties
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    private let theme = ThemeManager.shared.getThemeInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        listTableView.dataSource = self
        listTableView.delegate = self
        setListTableView()
        setSectionAndRecords()
        setBackButton()
        setSearchButton()
        initCalendar()
        view.bringSubviewToFront(listTableView)
        setEmptyMessage()
        showEmptyMessage()
    }
    
    @objc func backButtonPressed() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "mainViewController") as? MainViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
    }
    
    @objc func searchDateButtonPressed() {
        if searchDateButtonTag == false {
            searchDateButtonTag = true
            searchDateButton.isEnabled = false
            searchDateButton.setTitle("Hide Calendar", for: .normal)
            searchDateButtonIcon.image = UIImage(named: "SearchButtonClicked")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
                listTableView.frame.origin.y = listTableView.frame.origin.y + view.frame.width / 5 + calendarView.collectionViewLayout.collectionViewContentSize.height
            }) { (completed) in
                self.searchDateButton.isEnabled = true
            }
        } else {
            searchDateButtonTag = false
            searchDateButton.isEnabled = false
            searchDateButton.setTitle("Show Calendar", for: .normal)
            searchDateButtonIcon.image = UIImage(named: "SearchButton")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
                listTableView.frame.origin.y = listTableView.frame.origin.y - view.frame.width / 5 - calendarView.collectionViewLayout.collectionViewContentSize.height
            }) { (completed) in
                self.searchDateButton.isEnabled = true
            }
        }
    }
    
    @objc func dateFWButtonPressed() {
        components.month = (components.month ?? 1) + 1
        reloadCalendar()
    }
    
    @objc func dateBWButtonPressed() {
        components.month = (components.month ?? 1) - 1
        reloadCalendar()
    }
    
    private func reloadCalendar() {
        calendarCalculation()
        calendarView.reloadData()
        dateFWButton.isEnabled = false
        dateBWButton.isEnabled = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            listTableView.frame.origin.y = view.frame.height / 6 + 2 + view.frame.width / 5 + calendarView.collectionViewLayout.collectionViewContentSize.height
        }) { (completed) in
            self.dateFWButton.isEnabled = true
            self.dateBWButton.isEnabled = true
        }
    }
    
    private func setSectionAndRecords() {
        var rawRecords: [Record]?
        let context = CoreDataStack.shared.managedObjectContext
        let request = Record.fetchRequest()
        
        do { rawRecords = try context.fetch(request) } catch { print("context Error") }
        rawRecords?.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
        setDateSections(sortedRecords: rawRecords ?? [Record]())
    }
    
    private func initCalendar() {
        setCalendarViewConstraints()
        setCalendarDateLabel()
        setCalendarDateCtrButtons()
        registerCalendarView()
        dateFormatter.dateFormat = "yyyy . M"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        calendarCalculation()
    }
    
    private func setEmptyMessage() {
        emptyMessage.alpha = 0.0
        emptyMessage.text = "당신의 순간을 기록해보세요 :)"
        emptyMessage.textColor = UIColor(r: 202, g: 202, b: 202)
        emptyMessage.frame.size = CGSize(width: emptyMessage.intrinsicContentSize.width,
                                         height: emptyMessage.intrinsicContentSize.height)
        emptyMessage.center = CGPoint(x: listTableView.frame.width / 2,
                                      y: listTableView.frame.height * 0.1)
        listTableView.addSubview(emptyMessage)
    }
    
    private func showEmptyMessage() {
        if recordsByDate.count == 0 {
            emptyMessage.fadeIn()
        }
    }
}

// MARK: - calculate calendar
extension ListTableViewController: CalendarCollectionViewCellDelegate {
    func isCellPressed(sectionStr: String) {
        searchDateButtonPressed()
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: self.dateSections.firstIndex(of: sectionStr) ?? 0)
            self.listTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    private func calendarCalculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth ?? Date())
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth ?? Date())?.count ?? 0
        weekdayAdding = 2 - firstWeekday
        calendarDateLabel.text  = dateFormatter.string(from: firstDayOfMonth ?? Date())
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
}


// MARK: - set Calendar collection View
extension ListTableViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCalendarViewConstraints() {
        calendarView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        calendarView.frame.size = CGSize(width: view.frame.width,
                                         height: view.frame.width)
        calendarView.frame.origin = CGPoint(x: .zero,
                                            y: view.frame.height / 6 + view.frame.width / 5 + 2)
    }
    
    private func registerCalendarView() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCollectionViewCell
        
        cell?.dateDot.alpha = 0.0
        cell?.cellDateStr = nil
        cell?.isUserInteractionEnabled = false
        cell?.delegate = self
        
        if indexPath.row % 7 == 0 {
            cell?.dateLabel.textColor = UIColor(r: 72, g: 80, b: 84)
        } else if indexPath.row % 7 == 6 {
            cell?.dateLabel.textColor = UIColor(r: 72, g: 80, b: 84)
        } else {
            cell?.dateLabel.textColor = UIColor(r: 72, g: 80, b: 84)
        }
        
        switch indexPath.section {
        case 0:
            cell?.dateLabel.text = weeks[indexPath.row]
        default:
            cell?.dateLabel.text = days[indexPath.row]
            let cellDate = String(components.year ?? 2000) + ". " + String(components.month ?? 1) + ". " + days[indexPath.row]
            if let idx = onlyDateStr.firstIndex(of: cellDate) {
                cell?.dateDot.alpha = 1.0
                cell?.isUserInteractionEnabled = true
                cell?.cellDateStr = dateSections[idx]
            }
        }

        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let boundSize: CGFloat = view.bounds.size.width
        let cellSize: CGFloat = boundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
    
    private func setCalendarDateLabel() {
        calendarDateLabel.frame.size = CGSize(width: view.frame.width,
                                              height: view.frame.width / 5)
        calendarDateLabel.frame.origin = CGPoint(x: .zero,
                                                 y: view.frame.height / 6 + 2)
        calendarDateLabel.textAlignment = .center
        calendarDateLabel.textColor = UIColor(r: 72, g: 80, b: 84)
        calendarDateLabel.backgroundColor = .clear
        view.addSubview(calendarDateLabel)
        
    }
    
    private func setCalendarDateCtrButtons() {
        setDateFWButton()
        setDateBWButton()
        dateFWButton.addTarget(self, action: #selector(dateFWButtonPressed), for: .touchUpInside)
        dateBWButton.addTarget(self, action: #selector(dateBWButtonPressed), for: .touchUpInside)
    }
    
    private func setDateFWButton() {
        dateFWButton.frame.size = CGSize(width: view.frame.width / 10 * 0.9,
                                         height: view.frame.width / 10 * 0.9)
        dateFWButton.center = CGPoint(x: view.frame.width * 0.75,
                                      y: view.frame.height / 6 + 2 + (view.frame.width / 5 / 2))
        dateFWButton.setImage(UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dateFWButton.tintColor = UIColor(r: 72, g: 80, b: 84)
        dateFWButton.backgroundColor = .clear
        view.addSubview(dateFWButton)
    }
    
    private func setDateBWButton() {
        dateBWButton.frame.size = CGSize(width: view.frame.width / 10 * 0.9,
                                         height: view.frame.width / 10 * 0.9)
        dateBWButton.center = CGPoint(x: view.frame.width * 0.25,
                                      y: view.frame.height / 6 + 2 + (view.frame.width / 5 / 2))
        dateBWButton.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dateBWButton.tintColor = UIColor(r: 72, g: 80, b: 84)
        dateBWButton.backgroundColor = .clear
        view.addSubview(dateBWButton)
    }
}

// MARK: - TableView delegate and datasource delegate
extension ListTableViewController {
    private func setDateSections(sortedRecords: [Record]) {
        var tempRecords = [Record]()
        for r in sortedRecords {
            let date = r.createdDate ?? Date()
            let dateString = getSectionDateStr(date: date)
            
            if let _ = dateSections.firstIndex(of: dateString) {
                tempRecords.append(r)
            } else {
                dateSections.append(dateString)
                onlyDateStr.append(getOnlyDate(date: date))
                if tempRecords.count > 0 {
                    recordsByDate.append(tempRecords)
                    tempRecords = [Record]()
                }
                tempRecords.append(r)
            }
        }
        if sortedRecords.count > 0 {
            recordsByDate.append(tempRecords)
        }
        tempRecords.removeAll()
    }
    
    private func getSectionDateStr(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        let dateString = df.string(from: date)
        return dateString + "   " + date.dayOfWeek
    }
    
    private func getOnlyDate(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        let dateString = df.string(from: date)
        return dateString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordsByDate.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recordsByDate[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.timeLabel.text = getCellDateStr(date: recordsByDate[indexPath.section][indexPath.row].createdDate ?? Date())
        cell.shapeImage.image = theme.getImageByGaugeLevel(gaugeLevel: Int(recordsByDate[indexPath.section][indexPath.row].gaugeLevel))
        cell.shapeImage.tintColor = theme.getColorByGaugeLevel(gaugeLevel: Int(recordsByDate[indexPath.section][indexPath.row].gaugeLevel))
        if let memo = recordsByDate[indexPath.section][indexPath.row].memo {
            cell.userMemo.text = memo
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getCellDateStr(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "HH:mm"
        df.locale = Locale(identifier:"ko_KR")
        let dateString = df.string(from: date)
        return dateString
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor.black
        header?.contentView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let context = CoreDataStack.shared.managedObjectContext
            context.delete(recordsByDate[indexPath.section][indexPath.row])
            CoreDataStack.shared.saveContext()
            
            recordsByDate[indexPath.section].remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: .fade)
            if recordsByDate[indexPath.section].count == 0 {
                recordsByDate.remove(at: indexPath.section)
                dateSections.remove(at: indexPath.section)
                onlyDateStr.remove(at: indexPath.section)
                listTableView.deleteSections([indexPath.section], with: .fade)
                showEmptyMessage()
                calendarCalculation()
                calendarView.reloadData()
            }
        }
    }
    
    
}

// MARK: - Set List Table View
extension ListTableViewController {
    private func setListTableView() {
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(nibName, forCellReuseIdentifier: "listTableViewCell")
        listTableView.rowHeight  = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 80
        listTableView.separatorStyle = .none
        setListTableViwConstraints()
        listTableView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        view.addSubview(listTableView)
    }
    
    private func setListTableViwConstraints() {
        listTableView.frame.size = CGSize(width: view.frame.width,
                                          height: view.frame.height * 5 / 6)
        listTableView.frame.origin = CGPoint(x: .zero,
                                             y: view.frame.height / 6 + 2)
    }
}

// MARK: - set back button constraint and UI / set seperate line
extension ListTableViewController {
    
    private func setSearchButton() {
        setSearchButtonUI()
        setSearchButtonConstraints()
        searchDateButton.addTarget(self, action: #selector(searchDateButtonPressed), for: .touchUpInside)
    }
    
    private func setSearchButtonUI() {
        searchDateButton.setTitle("show Calendar", for: .normal)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .normal)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .highlighted)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .disabled)
        searchDateButton.backgroundColor = .clear
        searchDateButtonIcon.backgroundColor = .clear
        searchDateButtonIcon.image = UIImage(named: "SearchButton")?.withRenderingMode(.alwaysTemplate)
        searchDateButtonIcon.tintColor = .darkGray//UIColor(r: 229, g: 151, b: 139)
    }
    
    private func setSearchButtonConstraints() {
        searchDateButton.frame.size = CGSize(width: searchDateButton.intrinsicContentSize.width + view.frame.width / 10,
                                             height: view.frame.width / 10)
        searchDateButton.center = CGPoint(x: view.frame.width / 2,
                                          y: view.frame.height * 0.11)
        searchDateButtonIcon.frame.size = CGSize(width: view.frame.width / 10 * 0.5,
                                                 height: view.frame.width / 10 * 0.5)
        searchDateButtonIcon.center = CGPoint(x: searchDateButton.center.x + (searchDateButton.frame.width / 2) - (searchDateButtonIcon.frame.size.width),
                                              y: searchDateButton.center.y)
        view.addSubview(searchDateButtonIcon)
    }
    
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
