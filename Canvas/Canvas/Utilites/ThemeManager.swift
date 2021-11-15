import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private var userThemeValue: Int = 0
    
    private init() {}
    
    func setUserThemeValue(themeValue: Int) {
        userThemeValue = themeValue
    }
    
    func getThemeInstance() -> Theme {
        switch userThemeValue {
        case 0:
            return DefaultTheme.shared
        default:
            return DefaultTheme.shared
        }
    }
}

class Theme {
    func instanceImageSet() -> [UIImage] {
        return [UIImage]()
    }
    
    func getImageByGaugeLevel(gaugeLevel: Float, currentImage: UIImage?, imageSet: [UIImage]) -> UIImage? {
        let newImage = imageSet[Int(gaugeLevel / 5)]
        
        if currentImage == nil {
            return newImage
        } else {
            if currentImage == newImage {
                return nil
            } else {
                return newImage
            }
        }
    }
}

class DefaultTheme: Theme {
    static let shared = DefaultTheme()
    
    private override init() {
        super.init()
    }
    
    override func instanceImageSet() -> [UIImage] {
        let imageName = ["shape1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        var imageSet = [UIImage]()
        
        for name in imageName {
            imageSet.append(UIImage(named: name)?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        }
        return imageSet
    }
}
