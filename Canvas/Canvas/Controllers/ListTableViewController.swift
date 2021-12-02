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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    override var prefersStatusBarHidden: Bool {
        if UIDevice.hasNotch {
            return false
        } else {
            return true
        }
    }
    
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
        let swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        let calendarSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(dateFWButtonPressed))
        let calendarSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dateBWButtonPressed))
        swipe.edges = .left
        swipe.delegate = self
        calendarSwipeLeft.direction = .left
        calendarSwipeRight.direction = .right
        self.listTableView.addGestureRecognizer(swipe)
        self.calendarView.gestureRecognizers = [calendarSwipeLeft, calendarSwipeRight]
        setupFeedbackGenerator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.bringSubviewToFront(searchDateButtonIcon)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            impactFeedbackGenerator?.impactOccurred()
            calendarView.removeFromSuperview()
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.view.window?.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func backButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
        calendarView.removeFromSuperview()
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func searchDateButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
        if searchDateButtonTag == false {
            searchDateButtonTag = true
            searchDateButton.isEnabled = false
            searchDateButtonIcon.image = UIImage(named: "searchButtonClicked")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
                listTableView.frame.origin.y = listTableView.frame.origin.y + view.frame.width / 5 + calendarView.collectionViewLayout.collectionViewContentSize.height
            }) { (completed) in
                self.searchDateButton.isEnabled = true
            }
        } else {
            searchDateButtonTag = false
            searchDateButton.isEnabled = false
            searchDateButtonIcon.image = UIImage(named: "searchButton")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
                listTableView.frame.origin.y = listTableView.frame.origin.y - view.frame.width / 5 - calendarView.collectionViewLayout.collectionViewContentSize.height
            }) { (completed) in
                self.searchDateButton.isEnabled = true
            }
        }
    }
    
    @objc func dateFWButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
        components.month = (components.month ?? 1) + 1
        reloadCalendar()
    }
    
    @objc func dateBWButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
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
        recordsByDate = [[Record]]()
        onlyDateStr = [String]()
        dateSections = [String]()
        var rawDates = [FinalDate]()
        let context = CoreDataStack.shared.managedObjectContext
        let request = FinalDate.fetchRequest()
        do {
            rawDates = try context.fetch(request)
        } catch { print("context Error") }
        rawDates.sort(by: {$0.creationDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.creationDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
        for rawDate in rawDates {
            dateSections.append(getSectionDateStr(date: rawDate.creationDate ?? Date()))
            onlyDateStr.append(getOnlyDate(date: rawDate.creationDate ?? Date()))
            var rawRecords = rawDate.records?.allObjects as? [Record] ?? [Record]()
            rawRecords.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            recordsByDate.append(rawRecords)
        }
    }
    
    private func initCalendar() {
        setCalendarViewConstraints()
        setCalendarDateCtrButtons()
        setCalendarDateLabel()
        registerCalendarView()
        dateFormatter.dateFormat = "yyyy . M"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        calendarCalculation()
    }
    
    private func setEmptyMessage() {
        emptyMessage.alpha = 0.0
        emptyMessage.text = "당신의 순간을 기록해보세요 :)\n모인 기록들은 달력을 통해 손쉽게 찾아갈 수 있답니다!"
        
        let attrString = NSMutableAttributedString(string: emptyMessage.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        emptyMessage.attributedText = attrString
        emptyMessage.lineBreakMode = .byWordWrapping
        emptyMessage.numberOfLines = 0
        emptyMessage.textAlignment = .center
        emptyMessage.font = UIFont(name: "Pretendard-Regular", size: 15)
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

extension ListTableViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - calculate calendar
extension ListTableViewController: CalendarCollectionViewCellDelegate {
    func isCellPressed(sectionStr: String) {
        impactFeedbackGenerator?.impactOccurred()
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
        calendarDateLabel.font = UIFont(name: "Cardo-Bold", size: 17)
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
        cell?.dateLabel.font = UIFont(name: "Cardo-Regular", size: 12)
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
            if cellDate == getOnlyDate(date: Date()) {
                cell?.dateLabel.font = UIFont(name: "Cardo-Bold", size: 13)
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
        calendarDateLabel.snp.makeConstraints { make in
            calendarDateLabel.backgroundColor = .clear
            calendarDateLabel.text = "CANVAS"
            calendarDateLabel.font = UIFont(name: "JosefinSans-Regular", size: CGFloat(fontSize))
            calendarDateLabel.textColor = textColor
            calendarDateLabel.textAlignment = .center
            calendarDateLabel.frame.size = CGSize(width: calendarDateLabel.intrinsicContentSize.width,
                                                  height: calendarDateLabel.intrinsicContentSize.height)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.dateBWButton)
            view.addSubview(calendarDateLabel)
        }
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
    //    private func setDateSections(sortedRecords: [Record]) {
    //        var tempRecords = [Record]()
    //        for r in sortedRecords {
    //            let date = r.createdDate ?? Date()
    //            let dateString = getSectionDateStr(date: date)
    //
    //            if let _ = dateSections.firstIndex(of: dateString) {
    //                tempRecords.append(r)
    //            } else {
    //                dateSections.append(dateString)
    //                onlyDateStr.append(getOnlyDate(date: date))
    //                if tempRecords.count > 0 {
    //                    recordsByDate.append(tempRecords)
    //                    tempRecords = [Record]()
    //                }
    //                tempRecords.append(r)
    //            }
    //        }
    //        if sortedRecords.count > 0 {
    //            recordsByDate.append(tempRecords)
    //        }
    //        tempRecords.removeAll()
    //    }
    
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
        header?.textLabel?.font = UIFont(name: "Cardo-Bold", size: 14)
        header?.contentView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.presentDeletionFailsafe(indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        impactFeedbackGenerator?.impactOccurred()
        let alert = UIAlertController(title: nil, message: "정말 기록을 삭제할까요?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
            let context = CoreDataStack.shared.managedObjectContext
            let date = self.recordsByDate[indexPath.section][indexPath.row].createdDate ?? Date()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            context.delete(self.recordsByDate[indexPath.section][indexPath.row])
            CoreDataStack.shared.saveContext()
            self.recordsByDate[indexPath.section].remove(at: indexPath.row)
            self.listTableView.deleteRows(at: [indexPath], with: .fade)
            if self.recordsByDate[indexPath.section].count == 0 {
                var matchingDate = [FinalDate]()
                let fetchRequest = FinalDate.fetchRequest()
                let dateFrom = calendar.startOfDay(for: date)
                let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? Date()
                let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(FinalDate.creationDate))
                let toPredicate = NSPredicate(format: "%K < %@", #keyPath(FinalDate.creationDate), dateTo as NSDate)
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
                fetchRequest.predicate = datePredicate
                do {
                    matchingDate = try context.fetch(fetchRequest)
                } catch { print("context Error") }
                if matchingDate.count > 0 {
                    context.delete(matchingDate[0])
                }
                self.recordsByDate.remove(at: indexPath.section)
                self.dateSections.remove(at: indexPath.section)
                self.onlyDateStr.remove(at: indexPath.section)
                self.listTableView.deleteSections([indexPath.section], with: .fade)
                self.showEmptyMessage()
                self.calendarCalculation()
            }
            self.calendarView.reloadData()
            CoreDataStack.shared.saveContext()
            feedbackGenerator?.notificationOccurred(.success)
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            impactFeedbackGenerator?.impactOccurred()
        }
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
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
//        listTableView.snp.makeConstraints { make in
//            make.top.equalTo(searchDateButton.snp.bottom).offset(50)
//            make.leading.trailing.bottom.equalTo(self.view)
//        }
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
        searchDateButton.setTitle("Calendar", for: .normal)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .normal)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .highlighted)
        searchDateButton.setTitleColor(UIColor(r: 72, g: 80, b: 84), for: .disabled)
        searchDateButton.backgroundColor = .clear
        searchDateButtonIcon.backgroundColor = .clear
        searchDateButtonIcon.image = UIImage(named: "searchButton")?.withRenderingMode(.alwaysTemplate)
        searchDateButtonIcon.tintColor = .darkGray//UIColor(r: 229, g: 151, b: 139)
    }
    
    private func setSearchButtonConstraints() {
        let searchDateButtonLabel = UILabel()
        
        searchDateButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(backButtonIcon.snp.centerY)
            make.height.equalTo(buttonSize)
            make.width.equalTo(searchDateButton.intrinsicContentSize.width + 20)
            
            searchDateButton.setTitle("", for: .normal)
        }
        searchDateButtonIcon.snp.makeConstraints { make in
            make.centerY.equalTo(backButtonIcon.snp.centerY)
            make.size.equalTo(20)
            make.leading.equalTo(searchDateButton.snp.trailing).offset(-10)
            
            view.addSubview(searchDateButtonIcon)
        }
        searchDateButtonLabel.snp.makeConstraints { make in
            make.edges.equalTo(searchDateButton)
            
            searchDateButtonLabel.text = "Calendar"
            searchDateButtonLabel.textAlignment = .center
            searchDateButtonLabel.textColor = UIColor(r: 72, g: 80, b: 84)
            searchDateButtonLabel.font = UIFont(name: "Cardo-Bold", size: CGFloat(fontSize))
            searchDateButtonLabel.isUserInteractionEnabled = false
            view.addSubview(searchDateButtonLabel)
        }
    }
    
    private func setBackButton() {
        setBackButtonConstraints()
        setBackButtonUI()
        setSeperateLine()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func setBackButtonConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        backButtonIcon.snp.makeConstraints { make in
            make.size.equalTo(backButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(backButton)
            view.addSubview(backButtonIcon)
        }
    }
    
    private func setBackButtonUI() {
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        backButtonIcon.image = UIImage(systemName: "arrow.backward")
        backButtonIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        backButtonIcon.isUserInteractionEnabled = false
    }
    
    private func setSeperateLine() {
        let seperateUpperView = UIView()
        seperateUpperView.snp.makeConstraints { make in
            make.top.equalTo(searchDateButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            
            seperateUpperView.backgroundColor = .white
            view.addSubview(seperateUpperView)
        }
        
        let seperateUnderView = UIView()
        seperateUnderView.snp.makeConstraints { make in
            make.top.equalTo(seperateUpperView.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            
            seperateUnderView.backgroundColor = UIColor(r: 195, g: 201, b: 205)
            view.addSubview(seperateUnderView)
        }
    }
}

extension Date {
    var dayOfWeek: String {
        let formatter = DateFormatter()
        
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self)
    }
}
