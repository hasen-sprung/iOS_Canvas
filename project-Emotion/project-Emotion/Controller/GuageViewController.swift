//
//  ViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/10.
//

import UIKit
import Macaw

class GuageViewController: UIViewController {

    let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    let floatingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let floatingSVGViewCenter = FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let floatingSVGViewLeft = FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let floatingSVGViewRight = FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let animationGroup = try! SVGParser.parse(path: "emotions") as! Group

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // MARK: - [start] guage수신
        NotificationCenter.default.addObserver(self, selector: #selector(setFloatingView(_:)), name: Notification.Name(rawValue: "figureChanged"), object: nil)
        
        view.addSubview(gaugeView)
        view.addSubview(floatingView)
        floatingView.addSubview(floatingSVGViewCenter)
        floatingView.addSubview(floatingSVGViewRight)
        floatingView.addSubview(floatingSVGViewLeft)
        
        
        gaugeView.startWaveAnimation()
        
        
        setFloatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: - [start] navigationBar 투명
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        // [End] navigationBar 투명
        
        floatingSVGViewCenter.startSVGanimation(node: animationGroup,
                                           width: 50,
                                           height: 50,
                                           rangeX: 5,
                                           rangeY: -30,
                                           centerX: 0,
                                           centerY: 10,
                                           duration: 0.7)
        
        floatingSVGViewRight.startSVGanimation(node: animationGroup,
                                           width: 30,
                                           height: 30,
                                           rangeX: 8,
                                           rangeY: -40,
                                           centerX: 150,
                                           centerY: 20,
                                           duration: 0.5)
        
        floatingSVGViewLeft.startSVGanimation(node: animationGroup,
                                           width: 40,
                                           height: 40,
                                           rangeX: -5,
                                           rangeY: -50,
                                           centerX: -130,
                                           centerY: 30,
                                           duration: 0.9)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gaugeView.setGradientLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        gaugeView.stopWaveAnimation()
    }

    // MARK: - [start] floating base View setting and moving
    func setFloatingView() {
        
        floatingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        floatingView.backgroundColor = .clear
        floatingView.isUserInteractionEnabled = false
    }

    @objc func setFloatingView(_ notification: NSNotification) {
        
        if let figure = notification.userInfo?["figure"] as? Float {
            floatingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
            floatingView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * CGFloat(figure))
            floatingView.backgroundColor = .clear
            floatingView.isUserInteractionEnabled = false
        }
    }
    // [end] floating object base View setting and moving
}

