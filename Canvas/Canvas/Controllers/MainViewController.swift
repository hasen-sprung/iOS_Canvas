import UIKit
import SnapKit
import FirebaseAnalytics

class MainViewController: UIViewController {
    // Data
    private let launchedBefore = UserDefaults.shared.bool(forKey: "launchedBefore")
    private let userIDsetting = UserDefaults.shared.bool(forKey: "userIDsetting")
    private let themeManager = ThemeManager.shared
    
    private var recordsByDate = [[Record]]()
    private var dateStrings = [String]()
    var currentIndex: CGFloat = 0
    var isOneStepPaging = true
    
    // Main views
    private var mainCanvasLayout: UIView = UIView()
    private var mainInfoView: UIView = UIView()
    private var mainAddRecordButton: UIButton = UIButton()
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    private let mainViewLabel = UILabel()
    
    // Main views images
    private let addRecordIcon = UIImageView()
    private let goToListIcon = UIImageView()
    private let goToSettingIcon = UIImageView()
    
    // Sub views
    private var canvasRecordsView: MainRecordsView?
    private let infoContentView = MainInfoView()
    private let greetingView = UILabel()
    private var detailView = RecordDetailView()
    
    @IBOutlet weak var canvasCollectionView: UICollectionView!
    private var shouldInvalidateLayout = true
    
    private var isFirstInitInMainView: Bool = false
    private var countOfRecordInCanvas: Int = defaultCountOfRecordInCanvas
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
    
    private var animator: UIViewPropertyAnimator?
    private var willDisappear: Bool = false
    
    private var infoRecordIndex = 0
    
    override func loadView() {
        super.loadView()
        // MARK: - DEVELOP - init seedData :
//                DataHelper.shared.loadSeeder()
        // 처음 앱을 실행되었을 때 = 코어데이터에 아무것도 없는 상태이기 때문에, 레코드들의 위치정보를 제공해줘야 한다.
        if launchedBefore == false {
            UserDefaults.shared.set(true, forKey: "launchedBefore")
            UserDefaults.shared.set(true, forKey: "shakeAvail")
            UserDefaults.shared.set(true, forKey: "guideAvail")
            UserDefaults.shared.set(true, forKey: "canvasMode")
            UserDefaults.shared.synchronize()
            
            // MARK: - init position by Default Ratio
            // 레코드들의 포지션 정보(비율)를 초기화
            for i in 0..<countOfRecordInCanvas {
                let context = CoreDataStack.shared.managedObjectContext
                let position = DefaultPosition(context: context)
                
                position.xRatio = Ratio.DefaultRatio[i].x
                position.yRatio = Ratio.DefaultRatio[i].y
                CoreDataStack.shared.saveContext()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        canvasCollectionView.delegate = self
        canvasCollectionView.dataSource = self
        setAutoLayout()
        setButtonsTarget()
        setupFeedbackGenerator()
        setinfoViewUserAction()
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: .main) {
            [unowned self] notification in
            // background에서 foreground로 돌아오는 경우 실행 될 코드
            animate(command: "start")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        willDisappear = false
        
        updateContext()
        self.canvasCollectionView.reloadData()
        currentIndex = 0
        if dateStrings.count > 0 {
            mainViewLabel.text = dateStrings[0]
        } else {
            mainViewLabel.text = getDateString(date: Date())
        }
        let goTofirstAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
        goTofirstAnimation.addAnimations {
            self.canvasCollectionView?.contentOffset.x = 0
        }
        goTofirstAnimation.startAnimation()
        infoRecordIndex = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if shouldInvalidateLayout {
            canvasCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        // MARK: - 초기값에 프레임이 없기 때문에 여기에서 한번 무조건 초기화를 해줘야함
        if !isFirstInitInMainView {
            isFirstInitInMainView = true
            setShadows(mainInfoView)
            setShadows(mainCanvasLayout)
            setShadows(mainAddRecordButton, firstRadius: 36, secondRadius: 13, thirdRadius: 7)
            setInfoContentView()
            setCanvasCollectionView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shouldInvalidateLayout = false
        if userIDsetting == false {
            loadUserIdInputMode()
            UserDefaults.shared.synchronize()
        }
        if recordsByDate.count > 0 {
            animate(command: "start")
        }
        infoRecordIndex = 0
        setInfoContentView()
        infoContentView.setLastMemoView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willDisappear = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        canvasRecordsView?.clearRecordViews()
    }
    
    private func loadUserIdInputMode() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "userIdInputViewController") as? UserIdInputViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromBottom)
    }
    
    private func setinfoViewUserAction() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(infoviewSwipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(infoviewSwipeRight))
        let tap = UITapGestureRecognizer(target: self, action: #selector(infoviewTap))
        let greetingTap = UITapGestureRecognizer(target: self, action: #selector(changeGreetginMessage))
        let swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        swipe.edges = .right
        swipe.delegate = self
        swipeLeft.delegate = self
        swipeRight.delegate = self
        tap.delegate = self
        greetingTap.delegate = self
        infoContentView.addGestureRecognizer(swipeRight)
        infoContentView.addGestureRecognizer(swipeLeft)
        infoContentView.addGestureRecognizer(tap)
        greetingView.addGestureRecognizer(greetingTap)
        view.addGestureRecognizer(swipe)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            impactFeedbackGenerator?.impactOccurred()
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "listTableViewController") as? ListTableViewController else { return }
            transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
        }
    }
    
    @objc func changeGreetginMessage() {
        let greetingMessages = ["\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님! 어떤 하루를 보내고 계시나요?\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!",
                                "좋은 하루에요! \(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n틈틈히 느끼는 생각을 기록하시면서\n나만의 그림을 완성해보세요!",
                                "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님 오늘 날씨는 어떤가요?\n사소한 것도 기록 하다 보면\n소중한 추억이 쌓이게 될거에요!",
                                "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님은 기록만 열심히 하세요!\n저희는 앞으로 많은 작가들과 함께\n예쁜 기록을 만들어드릴게요!",
                                "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n오늘 밤 잠들기 전에\n작성한 기록들을 읽어보시는건 어때요?"]
        impactFeedbackGenerator?.impactOccurred()
        greetingView.text = greetingMessages[Int.random(in: 0 ..< greetingMessages.count)]
    }
    
    @objc func infoviewTap() {
        animate(command: "select")
        impactFeedbackGenerator?.impactOccurred()
    }
    
    @objc func infoviewSwipeLeft() {
        infoRecordIndex -= 1
        if infoRecordIndex < 0 {
            infoRecordIndex = 0
            feedbackGenerator?.notificationOccurred(.error)
            return
        }
        animate(command: "select")
        impactFeedbackGenerator?.impactOccurred()
        setInfoContentView()
    }
    
    @objc func infoviewSwipeRight() {
        let endIndex = (recordsByDate[Int(currentIndex)].count) - 1
        infoRecordIndex += 1
        if infoRecordIndex > endIndex {
            infoRecordIndex = endIndex
            feedbackGenerator?.notificationOccurred(.error)
            return
        }
        if infoRecordIndex > 9 {
            infoRecordIndex = 9
            feedbackGenerator?.notificationOccurred(.error)
            return
        }
        animate(command: "select")
        impactFeedbackGenerator?.impactOccurred()
        setInfoContentView()
    }
}

extension MainViewController {
    
    private func updateContext() {
        recordsByDate = [[Record]]()
        dateStrings = [String]()
        let context = CoreDataStack.shared.managedObjectContext
        if UserDefaults.shared.bool(forKey: "canvasMode") == true {
            var rawDates = [FinalDate]()
            let request = FinalDate.fetchRequest()
            do {
                rawDates = try context.fetch(request)
            } catch { print("context Error") }
            rawDates.sort(by: {$0.creationDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.creationDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            for rawDate in rawDates {
                dateStrings.append(getStartOfDateString(date: rawDate.creationDate))
                var rawRecords = rawDate.records?.allObjects as? [Record] ?? [Record]()
                rawRecords.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
                recordsByDate.append(rawRecords)
            }
            let todayString = getDateString(date: Date())
            if let _ = dateStrings.firstIndex(of: todayString) {
                return
            } else {
                dateStrings.insert(todayString, at: 0)
                recordsByDate.insert([Record](), at: 0)
            }
        } else {
            dateStrings.append(getDateString(date: Date()))
            var rawRecords = [Record]()
            let request = Record.fetchRequest()
            do {
                rawRecords = try context.fetch(request)
            } catch { print("context Error") }
            rawRecords.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            if rawRecords.count > 10 {
                var tempRecord = [Record]()
                for idx in 0 ..< 10 {
                    tempRecord.append(rawRecords[idx])
                }
                recordsByDate.append(tempRecord)
            } else {
                recordsByDate.append(rawRecords)
            }
        }
    }
    
    private func getStartOfDateString(date: Date?) -> String{
        return getDateString(date: Calendar.current.startOfDay(for: date ?? Date()))
    }
    
}


extension MainViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainCanavasCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func setCanvasSubView(subView: MainRecordsView, idx: Int) {
        subView.setRecordViewsCount(to: countOfRecordInCanvas)
        subView.delegate = self
        subView.setRecordViews(records: recordsByDate[idx], theme: themeManager.getThemeInstance(), idx: idx)
    }
    
    private func setCanvasCollectionView() {
        canvasCollectionView.frame.size = CGSize(width: mainCanvasLayout.frame.width, height: mainCanvasLayout.frame.height)
        canvasCollectionView.center = mainCanvasLayout.center
        canvasCollectionView.backgroundColor = .clear
        canvasCollectionView.clipsToBounds = true
        canvasCollectionView.allowsSelection = false
        
        let cellWidth = mainCanvasLayout.frame.width
        let cellHeight = mainCanvasLayout.frame.height
        let insetX: CGFloat = 0//(view.bounds.width - cellWidth) / 2.0
        let insetY: CGFloat = 0
        
        let layout = canvasCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        canvasCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        canvasCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        view.addSubview(canvasCollectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordsByDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCanavasCollectionViewCell", for: indexPath) as? MainCanavasCollectionViewCell
        cell?.delegate = self
        cell?.index = indexPath.row
        collectionView.transform = CGAffineTransform(scaleX:-1,y: 1);
        cell?.transform = CGAffineTransform(scaleX:-1,y: 1);
        return cell ?? UICollectionViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getDateString(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        return df.string(from: date)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.canvasCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        // idle애니메이션 Start / Stop by Current CollectionCell Index
        if isOneStepPaging && (currentIndex != roundedIndex) {
            let num: CGFloat = currentIndex > roundedIndex ?  -1.0 : 1.0
            
            infoRecordIndex = 0
            animate(command: "stop")
            currentIndex += num
            roundedIndex = currentIndex
            mainViewLabel.text = dateStrings[Int(currentIndex)]
            animate(command: "start")
            setInfoContentView()
            impactFeedbackGenerator?.impactOccurred()
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

// MARK: - Auto Layout & Set Subviews

extension MainViewController {
    private func setAutoLayout() {
        // MARK: - Main Views Layout
        mainViewLabel.snp.makeConstraints { make in
            mainViewLabel.backgroundColor = .clear
            mainViewLabel.text = getDateString(date: Date())
            mainViewLabel.font = UIFont(name: "Cardo-Bold", size: CGFloat(fontSize))
            mainViewLabel.textColor = textColor
            mainViewLabel.textAlignment = .center
            mainViewLabel.frame.size = CGSize(width: mainViewLabel.intrinsicContentSize.width,
                                              height: mainViewLabel.intrinsicContentSize.height)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea + 10)
            view.addSubview(mainViewLabel)
        }
        goToListButton.snp.makeConstraints { make in
            goToListButton.backgroundColor = .clear
            goToListButton.setTitle("", for: .normal)
            goToListButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        goToSettingButton.snp.makeConstraints { make in
            goToSettingButton.backgroundColor = .clear
            goToSettingButton.setTitle("", for: .normal)
            goToSettingButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        mainAddRecordButton.snp.makeConstraints { make in
            mainAddRecordButton.backgroundColor = .clear
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-paddingInSafeArea)
            make.centerX.equalTo(self.view)
            make.size.equalTo(addButtonSize)
            view.addSubview(mainAddRecordButton)
        }
        mainInfoView.snp.makeConstraints { make in
            mainInfoView.backgroundColor = .white
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.bottom.equalTo(mainAddRecordButton.snp.top).offset(-paddingInSafeArea)
            make.height.equalTo(infoHeight)
            view.addSubview(mainInfoView)
        }
        mainCanvasLayout.snp.makeConstraints { make in
            mainCanvasLayout.backgroundColor = .white
            make.top.equalTo(goToListButton.snp.bottom).offset(paddingInSafeArea)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.bottom.equalTo(mainInfoView.snp.top).offset(-paddingInSafeArea)
            mainCanvasLayout.backgroundColor = .white
            view.addSubview(mainCanvasLayout)
        }
        
        // MARK: - Icons Layout
        goToListIcon.snp.makeConstraints { make in
            goToListIcon.image = UIImage(named: "ListBtnIcon")
            goToListIcon.isUserInteractionEnabled = false
            make.size.equalTo(goToListButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(goToListButton)
            view.addSubview(goToListIcon)
        }
        goToSettingIcon.snp.makeConstraints { make in
            goToSettingIcon.image = UIImage(named: "SettingBtnIcon")
            goToSettingIcon.isUserInteractionEnabled = false
            make.size.equalTo(goToSettingButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(goToSettingButton)
            view.addSubview(goToSettingIcon)
        }
        addRecordIcon.snp.makeConstraints { make in
            addRecordIcon.image = UIImage(named: "AddRecordBtnIcon")?.withRenderingMode(.alwaysTemplate)
            addRecordIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
            addRecordIcon.isUserInteractionEnabled = false
            make.size.equalTo(mainAddRecordButton).multipliedBy(0.35)
            make.center.equalTo(mainAddRecordButton)
            view.addSubview(addRecordIcon)
        }
    }
}

// MARK: - Set Animation and Gesture

extension MainViewController {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let isShake = UserDefaults.shared.bool(forKey: "shakeAvail")
        let indexPath = IndexPath(item: Int(currentIndex), section: 0)
        
        if !willDisappear && isShake && motion == .motionShake {
            feedbackGenerator?.notificationOccurred(.success)
            if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                cell.canvasRecordView?.resetRandomPosition(records: recordsByDate[Int(currentIndex)], idx: Int(currentIndex))
                shakeAnimation(canvasRecordsView: cell.canvasRecordView!)
            }
            motionEnded(motion, with: event)
        }
    }
    
    private func animate(command: String) {
        let indexPath = IndexPath(item: Int(currentIndex), section: 0)
        
        if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
            if let view = cell.canvasRecordView {
                switch command {
                case "start":
                    startRecordsAnimation(view: view)
                case "select":
                    addSelectAnimation(view: view)
                case "stop":
                    stopRecordsAnimation(view: view)
                default:
                    print("")
                }
            }
        }
    }
    
    private func shakeAnimation(canvasRecordsView: MainRecordsView) {
        let records = recordsByDate[Int(currentIndex)]
        var index = 0
        let recordViews = canvasRecordsView.getRecordViews()
        
        for view in recordViews {
            if index < records.count {
                addShakeAnimatorWithRecord(view: view, superview: canvasRecordsView, xRatio: records[index].xRatio, yRatio: records[index].yRatio)
            } else if currentIndex == 0  && UserDefaults.shared.bool(forKey: "guideAvail") == true {
                if let xRatio = DefaultRecord.data[index].x, let yRatio = DefaultRecord.data[index].y {
                    addShakeAnimatorWithRecord(view: view, superview: canvasRecordsView, xRatio: xRatio, yRatio: yRatio)
                }
            }
            index += 1
        }
    }
    private func addShakeAnimatorWithRecord(view: UIView, superview: UIView, xRatio: Float, yRatio: Float) {
        animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut)
        animator?.addAnimations {
            view.center = CGPoint(x: CGFloat(xRatio) * superview.frame.width,
                                  y: CGFloat(yRatio) * superview.frame.height)
        }
        animator?.addCompletion({ pos in
        })
        animator?.startAnimation()
    }
    
    private func startRecordsAnimation(view: MainRecordsView) {
        let recordViews = view.getRecordViews()
        var move: CGFloat
        
        if let size = view.getRecordSize() {
            move = size / 5
        } else {
            move = 10
        }
        for view in recordViews {
            addIdleAnimation(view: view, move: move)
        }
    }
    private func addIdleAnimation(view: UIView, move: CGFloat) {
        let index = self.currentIndex
        
        animator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut)
        animator?.addAnimations {
            let centerY = view.center.y
            view.center.y = centerY - CGFloat(move)
        }
        animator?.addCompletion({ pos in
            if index == self.currentIndex && !self.willDisappear {
                if UIApplication.shared.applicationState == .active {
                    self.addIdleAnimation(view: view, move: -move)
                }
            }
        })
        animator?.startAnimation(afterDelay: Double.random(in: 0.0...1.0))
    }
    
    private func addSelectAnimation(view: MainRecordsView) {
        let views = view.getRecordViews()
        
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn)
        animator?.addAnimations {
            views[self.infoRecordIndex].alpha = 0.0
            self.infoContentView.isUserInteractionEnabled = false
        }
        animator?.addCompletion({ pos in
            views[self.infoRecordIndex].alpha = 1.0
            self.infoContentView.isUserInteractionEnabled = true
        })
        animator?.startAnimation()
    }
    
    private func stopRecordsAnimation(view: MainRecordsView) {
        let recordViews = view.getRecordViews()
        
        for _ in recordViews {
            stopAnimator()
        }
    }
    private func stopAnimator() {
    }
}

// MARK: - Set Buttons Target

extension MainViewController {
    private func setButtonsTarget() {
        mainAddRecordButton.addTarget(self, action: #selector(addRecordButtonPressed), for: .touchUpInside)
        goToListButton.addTarget(self, action: #selector(goToListButtonPressed), for: .touchUpInside)
        goToSettingButton.addTarget(self, action: #selector(goToSettingPressed), for: .touchUpInside)
    }
    
    @objc func addRecordButtonPressed(_ sender: UIButton) {
        impactFeedbackGenerator?.impactOccurred()
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "gaugeViewController") as? GaugeViewController else { return }
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func goToListButtonPressed(_ sender: UIButton) {
        impactFeedbackGenerator?.impactOccurred()
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "listTableViewController") as? ListTableViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
    }
    
    @objc func goToSettingPressed(_ sender: UIButton) {
        impactFeedbackGenerator?.impactOccurred()
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingViewController") as? SettingViewController else { return }
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - set info Content view in info view

extension MainViewController: MainInfoViewDelegate {
    
    func getLastRecord() -> Record? {
        if recordsByDate.count > 0 {
            if recordsByDate[Int(currentIndex)].count > 0 {
                return recordsByDate[Int(currentIndex)][infoRecordIndex]
            }
        }
        return nil
    }
    
    func getCurrentIndex() -> Int {
        return Int(currentIndex)
    }
    
    func getInfoDateString() -> String {
        var recordCount = recordsByDate[Int(currentIndex)].count
        let df = DateFormatter()
        if recordCount > 10 {
            recordCount = 10
        }
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        if recordCount >= 1 {
            let firstDate = df.string(from: recordsByDate[Int(currentIndex)][recordCount - 1].createdDate ?? Date())
            let lastDate = df.string(from: recordsByDate[Int(currentIndex)][0].createdDate ?? Date())
            if firstDate == lastDate {
                return firstDate
            } else {
                return firstDate + " ~ " + lastDate
            }
        } else {
            return ""
        }
    }
    
    func setInfoContentView() {
        infoContentView.delegate = self
        infoContentView.backgroundColor = .clear
        infoContentView.frame.size = CGSize(width: mainInfoView.frame.width - 20, height: mainInfoView.frame.height - 20)
        infoContentView.center = mainInfoView.center
        
        if recordsByDate.count > 0 && recordsByDate[Int(currentIndex)].count > 0 {
            view.addSubview(infoContentView)
            view.bringSubviewToFront(infoContentView)
            greetingView.removeFromSuperview()
            infoContentView.setLastMemoView()
            //            infoContentView.setShapesView(records: recordsByDate[Int(currentIndex)])
        } else {
            infoContentView.removeFromSuperview()
            greetingView.lineBreakMode = .byWordWrapping
            greetingView.numberOfLines = 0
            let greetingMessages = ["\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님! 어떤 하루를 보내고 계시나요?\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!",
                                    "좋은 하루에요! \(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n틈틈히 느끼는 생각을 기록하시면서\n나만의 그림을 완성해보세요!",
                                    "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님 오늘 날씨는 어떤가요?\n사소한 것도 기록 하다 보면\n소중한 추억이 쌓이게 될거에요!",
                                    "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님은 기록만 열심히 하세요!\n저희는 앞으로 많은 작가들과 함께\n예쁜 기록을 만들어드릴게요!",
                                    "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n오늘 밤 잠들기 전에\n작성한 기록들을 읽어보시는건 어때요?"]
            greetingView.text = greetingMessages[Int.random(in: 0 ..< greetingMessages.count)]
            
            greetingView.font = UIFont(name: "Pretendard-Regular", size: 14)
            greetingView.textColor = UIColor(r: 72, g: 80, b: 84)
            
            let attrString = NSMutableAttributedString(string: greetingView.text ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            greetingView.attributedText = attrString
            greetingView.textAlignment = .center
            greetingView.snp.makeConstraints { make in
                make.edges.equalTo(self.mainInfoView).inset(5)
                view.addSubview(greetingView)
            }
            
            view.bringSubviewToFront(greetingView)
            greetingView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - MainRecordsViewDelegate

extension MainViewController: MainRecordsViewDelegate {
    func openRecordTextView(index: Int) {
        impactFeedbackGenerator?.impactOccurred()
        let df = DateFormatter()
        
        df.dateFormat = "M / d EEEE HH:mm"
        if index <= recordsByDate[Int(currentIndex)].count - 1 {
            detailView = RecordDetailView()
            detailView.frame = view.frame
            view.addSubview(detailView)
            detailView.setDetailView()
            detailView.shapeImage.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int(recordsByDate[Int(currentIndex)][index].gaugeLevel))
            detailView.shapeImage.tintColor = DefaultTheme.shared.getColorByGaugeLevel(gaugeLevel: Int(recordsByDate[Int(currentIndex)][index].gaugeLevel))
            detailView.dateLabel.text = df.string(from: recordsByDate[Int(currentIndex)][index].createdDate ?? Date())
            detailView.memo.text = recordsByDate[Int(currentIndex)][index].memo
        } else {
            detailView = RecordDetailView()
            detailView.frame = view.frame
            view.addSubview(detailView)
            detailView.setDetailView()
            detailView.memo.text = DefaultRecord.data[index].memo//"이곳에 랜덤한 설명이 들어갑니다."
        }
        
        let attrString = NSMutableAttributedString(string: detailView.memo.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        detailView.memo.attributedText = attrString
        detailView.memo.textAlignment = .left
        detailView.memo.textColor = UIColor(r: 41, g: 46, b: 48)
        detailView.memo.font = UIFont(name: "Pretendard-Regular", size: 15)
    }
    
    func tapActionRecordView() {
    }
}

var feedbackGenerator: UINotificationFeedbackGenerator?
var impactFeedbackGenerator: UIImpactFeedbackGenerator?

func setupFeedbackGenerator() {
    feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator?.prepare()
    impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
}

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
