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
//        Theme.shared.colors = newColors
    }
    
    @IBAction func pressedThemeDefault(_ sender: Any) {
        changeThemeColorSetUserDefault(themeColor: defaultColor)
    }
    
    @IBAction func pressedThemeCustom(_ sender: Any) {
        changeThemeColorSetUserDefault(themeColor: customColor)
    }
    
    @IBAction func pressedThemeNew(_ sender: Any) {
        changeThemeColorSetUserDefault(themeColor: seoulColor)
    }
    
    // MARK: - User Default에 변경값 저장, 테마싱글톤에 현재 선택된 테마 적용
    func changeThemeColorSetUserDefault(themeColor: Int) {
        UserDefaults.standard.set(themeColor, forKey: userDefaultColor)
        Theme.shared.colors = ThemeColors(theme: themeColor)
        print("changed the user default color to \(themeColor)")
    }
}
