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
    let floatingAreaView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
   
    
    var floatingSVGViews = [FloatingSVGView]()
    let svgGroup = try! SVGParser.parse(path: "emotions") as! Group

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // MARK: - [start] guage figure 수신
        NotificationCenter.default.addObserver(self, selector: #selector(getFigureStatus(_:)), name: Notification.Name(rawValue: "figureChanged"), object: nil)
        // [end] guage figure 수신
        
        // MARK: - [start] svg view 생성
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        // [end] svg view 생성
        
        view.addSubview(gaugeView)
        view.addSubview(floatingAreaView)
        
        for idx in 1...floatingSVGViews.count {
        
            floatingAreaView.addSubview(floatingSVGViews[idx - 1])
        }
        
        
        gaugeView.startWaveAnimation()
        setFloatingAreaView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: - [start] navigationBar 투명
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        // [End] navigationBar 투명
        
        floatingSVGViews[0].startSVGanimation(node: svgGroup,
                                           width: 60,
                                           height: 60,
                                           rangeX: 5,
                                           rangeY: -30,
                                           centerX: 0,
                                           centerY: 15,
                                           duration: 0.9,
                                           delay: 0.2)
        
        floatingSVGViews[1].startSVGanimation(node: svgGroup,
                                           width: 40,
                                           height: 40,
                                           rangeX: 14,
                                           rangeY: -40,
                                           centerX: 150,
                                           centerY: 23,
                                           duration: 0.7,
                                           delay: 0)
        
        floatingSVGViews[2].startSVGanimation(node: svgGroup,
                                           width: 50,
                                           height: 50,
                                           rangeX: -5,
                                           rangeY: -50,
                                           centerX: -130,
                                           centerY: 33,
                                           duration: 1.1,
                                           delay: 0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    func setFloatingAreaView() {
        
        floatingAreaView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingAreaView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        floatingAreaView.backgroundColor = .clear
        floatingAreaView.isUserInteractionEnabled = false
    }

    @objc func getFigureStatus(_ notification: NSNotification) {
        
        if let figure = notification.userInfo?["figure"] as? Float {
            floatingAreaView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
            floatingAreaView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * CGFloat(figure))
            floatingAreaView.backgroundColor = .clear
            floatingAreaView.isUserInteractionEnabled = false
            
            for idx in 1...floatingSVGViews.count {
                floatingSVGViews[idx - 1].changeSVGShape(figure: figure)
            }
        }
        
       
    }
    // [end] floating object base View setting and moving
}

