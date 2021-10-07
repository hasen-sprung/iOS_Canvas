
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
    }
    
    @IBAction func pressedThemeDefault(_ sender: Any) {
        changeThemeColorSetUserDefault(themeValue: defaultColor)
    }
    
    @IBAction func pressedThemeCustom(_ sender: Any) {
        changeThemeColorSetUserDefault(themeValue: customColor)
    }
    
    @IBAction func pressedThemeNew(_ sender: Any) {
        changeThemeColorSetUserDefault(themeValue: seoulColor)
    }
    
    // MARK: - User Default에 변경값 저장, 테마싱글톤에 현재 선택된 테마 적용
    func changeThemeColorSetUserDefault(themeValue: Int) {
        UserDefaults.standard.set(themeValue, forKey: userDefaultColor)
        ThemeManager.shared.setUserThemeValue(themeValue: themeValue)
        print("changed the user default color to \(themeValue)")
    }
}
