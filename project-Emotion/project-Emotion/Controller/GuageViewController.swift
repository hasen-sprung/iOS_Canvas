//
//  ViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/10.
//

import UIKit

class GuageViewController: UIViewController {

    let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    let floatingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setFloatingView(_:)), name: Notification.Name(rawValue: "figureChanged"), object: nil)
        view.addSubview(floatingView)
        view.addSubview(gaugeView)
        gaugeView.startWaveAnimation()
        setFloatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gaugeView.setGradientLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gaugeView.stopWaveAnimation()
    }

    func setFloatingView() {
        
        floatingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        floatingView.alpha = 0.1
        floatingView.backgroundColor = .cyan
    }

    @objc func setFloatingView(_ notification: NSNotification) {
        
        if let figure = notification.userInfo?["figure"] as? Float {
            floatingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
            floatingView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * CGFloat(figure))
            floatingView.alpha = 0.1
            floatingView.backgroundColor = .cyan
        }
    }
}

