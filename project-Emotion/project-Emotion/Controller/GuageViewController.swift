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
    let floatingSVGView = FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - [start] 수신
        NotificationCenter.default.addObserver(self, selector: #selector(setFloatingView(_:)), name: Notification.Name(rawValue: "figureChanged"), object: nil)
        
        view.addSubview(gaugeView)
        view.addSubview(floatingView)
        floatingView.addSubview(floatingSVGView)
        
        setFloatingView()
        floatingSVGView.setFloatingSVGView(node: [Node](),
                                           width: 50,
                                           height: 50,
                                           range: 40)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: - [start] navigationBar 투명
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        // [End] navigationBar 투명

    
        gaugeView.startWaveAnimation()
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

