//
//  ViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/10.
//

import UIKit

class ViewController: UIViewController {

    let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(gaugeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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


}

