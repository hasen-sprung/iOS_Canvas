//
//  SettingViewController.swift
//  project-Emotion
//
//  Created by Jaeyoung Lee on 2021/09/29.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func pressedTestBtn(_ sender: UIButton) {
        print("change color")
        let newColors = ThemeColors(gaugeViewBackgroundColor: .darkGray, gaugeViewColorBottom: .red, gaugeViewColorTop: .blue, mainViewBackgroundColor: .black, mainViewBackgroundSubColor: .brown)
        Theme.shared.colors = newColors
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
