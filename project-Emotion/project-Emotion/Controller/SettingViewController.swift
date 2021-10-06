//
//  SettingViewController.swift
//  project-Emotion
//
//  Created by Jaeyoung Lee on 2021/09/29.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var ThemeDefaultBtn: UIButton!
    @IBOutlet weak var ThemeCustomBtn: UIButton!
    @IBOutlet weak var ThemeNewBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func pressedTestBtn(_ sender: UIButton) {
        print("change color")
        let newColors = ThemeColors(gaugeViewBackgroundColor: .darkGray, gaugeViewColorBottom: .red, gaugeViewColorTop: .blue, mainViewBackgroundColor: .black, mainViewBackgroundSubColor: .brown)
        Theme.shared.colors = newColors
    }
    
    @IBAction func pressedThemeDefault(_ sender: Any) {
        changeThemeColor(themeColor: defaultColor)
    }
    
    @IBAction func pressedThemeCustom(_ sender: Any) {
        changeThemeColor(themeColor: customColor)
    }
    
    @IBAction func pressedThemeNew(_ sender: Any) {
        changeThemeColor(themeColor: seoulColor)
    }
    
    func changeThemeColor(themeColor: Int) {
        UserDefaults.standard.set(themeColor, forKey: userDefaultColor)
        print("changed the user default color to \(themeColor)")
    }
}
