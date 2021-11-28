import UIKit
import SnapKit

class MainViewController: UIViewController {
    // Data
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    private let userIDsetting = UserDefaults.standard.bool(forKey: "userIDsetting")
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
    private var animator: UIViewPropertyAnimator?
    
    override func loadView() {
        super.loadView()
        // MARK: - DEVELOP - init seedData :
//                DataHelper.shared.loadSeeder()
        // 처음 앱을 실행되었을 때 = 코어데이터에 아무것도 없는 상태이기 때문에, 레코드들의 위치정보를 제공해줘야 한다.
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set("Canvas", forKey: "canvasTitle")
            UserDefaults.standard.set(true, forKey: "shakeAvail")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        canvasCollectionView.delegate = self
        canvasCollectionView.dataSource = self
        setAutoLayout()
        setButtonsTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willappear")
        updateContext()
        setInfoContentView()
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
            UserDefaults.standard.synchronize()
        }
        if recordsByDate.count > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                if let view = cell.canvasRecordView {
                    startRecordsAnimation(view: view)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        canvasRecordsView?.clearRecordViews()
    }
    
    private func updateContext() {
        var rawRecords = [Record]()
        let context = CoreDataStack.shared.managedObjectContext
        let request = Record.fetchRequest()
        do {
            rawRecords = try context.fetch(request)
        } catch { print("context Error") }
        rawRecords.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
        setRecordsByDate(sortedRecords: rawRecords)
    }
    
    private func loadUserIdInputMode() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "userIdInputViewController") as? UserIdInputViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromBottom)
    }
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainCanavasCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected collectionView")
    }
    
    func setCanvasSubView(subView: MainRecordsView, idx: Int) {
        subView.setRecordViewsCount(to: countOfRecordInCanvas)
        subView.delegate = self
        subView.setRecordViews(records: recordsByDate[idx], theme: themeManager.getThemeInstance())
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
    
    private func setRecordsByDate(sortedRecords: [Record]) {
        recordsByDate = [[Record]]()
        dateStrings = [String]()
        var tempRecords = [Record]()
        for r in sortedRecords {
            let date = r.createdDate ?? Date()
            let dateString = getDateString(date: date)
            
            if let _ = dateStrings.firstIndex(of: dateString) {
                tempRecords.append(r)
            } else {
                dateStrings.append(dateString)
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
        
        // MARK: - TODO: 여기서 애니메이션 스타트를 하고 중지를 하는게 맞는지는 모르겠어요!!!
        // 일단 콜렉션 뷰 안에서 캔버스가 변경될 때마다 idle애니메이션을 끄고 / 키고 해야할 것 같습니다.
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                var indexPath = IndexPath(item: Int(currentIndex), section: 0)
                if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                    if let view = cell.canvasRecordView {
                        print("stop")
                        stopRecordsAnimation(view: view)
                    }
                }
                currentIndex -= 1
                roundedIndex = currentIndex
                mainViewLabel.text = dateStrings[Int(currentIndex)]
                indexPath = IndexPath(item: Int(currentIndex), section: 0)
                if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                    if let view = cell.canvasRecordView {
                        print("start")
                        startRecordsAnimation(view: view)
                    }
                }

            } else if currentIndex < roundedIndex {
                var indexPath = IndexPath(item: Int(currentIndex), section: 0)
                if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                    if let view = cell.canvasRecordView {
                        print("stop")
                        stopRecordsAnimation(view: view)
                    }
                }
                currentIndex += 1
                roundedIndex = currentIndex
                mainViewLabel.text = dateStrings[Int(currentIndex)]
                indexPath = IndexPath(item: Int(currentIndex), section: 0)
                if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                    if let view = cell.canvasRecordView {
                        print("start")
                        startRecordsAnimation(view: view)
                    }
                }
            }
        }
        print("current index: ", Int(currentIndex))

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
            goToListButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        goToSettingButton.snp.makeConstraints { make in
            goToSettingButton.backgroundColor = .clear
            goToSettingButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
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
        
//        infoContentView.snp.makeConstraints { make in
//            make.edges.equalTo(mainInfoView).inset(10)
//            view.addSubview(infoContentView)
//        }
    }
    
//    private func setRecordsViewInCanvas(subView: UIView) {
//        // canvas ui의 frame, layout이 정해진 후 레코드뷰들을 생성해야 함
//        canvasRecordsView = MainRecordsView(in: subView)
//        if let recordsView = canvasRecordsView {
//            subView.addSubview(recordsView)
//            // 메인 뷰에서 출력되는 숫자는 차후 유저디폴트로 세팅가능하게, 초기값은 10
//            recordsView.setRecordViewsCount(to: countOfRecordInCanvas)
//            recordsView.delegate = self
//        }
//    }
}

// MARK: - Set Animation and Gesture

extension MainViewController {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let isShake = UserDefaults.standard.bool(forKey: "shakeAvail")
        let indexPath = IndexPath(item: Int(currentIndex), section: 0)
        
        if isShake && motion == .motionShake {
            if let cell = canvasCollectionView.cellForItem(at: indexPath) as? MainCanavasCollectionViewCell {
                cell.canvasRecordView?.setRandomPosition(records: recordsByDate[Int(currentIndex)])
                shakeAnimation(canvasRecordsView: cell.canvasRecordView!)
            }
            motionEnded(motion, with: event)
        }
    }
    
    private func shakeAnimation(canvasRecordsView: MainRecordsView) {
        let records = recordsByDate[Int(currentIndex)]
        var index = 0
        let recordViews = canvasRecordsView.getRecordViews()
        
        for view in recordViews {
            addShakeAnimator(view: view, record: records[index], superview: canvasRecordsView)
            index += 1
        }
    }
    private func addShakeAnimator(view: UIView, record: Record, superview: UIView) {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear)
        animator?.addAnimations {
            view.center = CGPoint(x: CGFloat(record.xRatio) * superview.frame.width,
                                  y: CGFloat(record.yRatio) * superview.frame.height)
        }
        animator?.addCompletion({ _ in
            print("finished shake")
        })
        animator?.startAnimation()
    }
    
    private func startRecordsAnimation(view: MainRecordsView) {
        let recordViews = view.getRecordViews()
        var move: CGFloat
        
        if let size = view.getRecordSize() {
            move = size / 4
        } else {
            move = 10
        }
        for view in recordViews {
            addIdleAnimation(view: view, move: move)
        }
    }
    private func addIdleAnimation(_ reversed: Bool = false, view: UIView, move: CGFloat) {
        animator = UIViewPropertyAnimator(duration: 2.0, curve: .linear)
        animator?.addAnimations {
            let centerY = view.center.y
            view.center.y = centerY - CGFloat(move)
        } 
        animator?.addCompletion({ _ in
            self.addIdleAnimation(!reversed, view: view, move: -move)
        })
        animator?.startAnimation(afterDelay: Double.random(in: 0.0...1.5))
    }
    
    private func stopRecordsAnimation(view: MainRecordsView) {
        let recordViews = view.getRecordViews()

        for _ in recordViews {
            stopAnimator()
        }
    }
    private func stopAnimator() {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .current)
//        animator?.stopAnimation(true)
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
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "gaugeViewController") as? GaugeViewController else { return }
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func goToListButtonPressed(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "listTableViewController") as? ListTableViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromLeft)
    }
    
    @objc func goToSettingPressed(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingViewController") as? SettingViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
    }
}

// MARK: - set info Content view in info view
extension MainViewController: MainInfoViewDelegate {
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
            greetingView.removeFromSuperview()
            infoContentView.setInfoViewContentSize()
            infoContentView.setInfoViewContentLayout()
            infoContentView.setDateLabel()
        } else {
            infoContentView.removeFromSuperview()
            greetingView.lineBreakMode = .byWordWrapping
            greetingView.numberOfLines = 0
            greetingView.text = "안녕하세요 \(UserDefaults.standard.string(forKey: "userID") ?? "무명작가")님!\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!"
            greetingView.font = UIFont(name: "Pretendard-Regular", size: 14)
            greetingView.textColor = UIColor(r: 72, g: 80, b: 84)
            
            let attrString = NSMutableAttributedString(string: greetingView.text ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            greetingView.attributedText = attrString
            greetingView.textAlignment = .center
            greetingView.frame.size = CGSize(width: greetingView.intrinsicContentSize.width,
                                             height: greetingView.intrinsicContentSize.height)
            greetingView.center = mainInfoView.center
            view.addSubview(greetingView)
        }
    }
}

// MARK: - MainRecordsViewDelegate

extension MainViewController: MainRecordsViewDelegate {
    func openRecordTextView(index: Int) {
        print("record")
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
            detailView.memo.text = DefaultRecord.records[index].memo//"이곳에 랜덤한 설명이 들어갑니다."
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
        print("tap")
    }
}
