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
    var backGroundColor: UIColor
    var gradientColors: [CGColor]
    var changeGradientColors: [CGColor]
    var images: [UIImage]?

    init(backGroundColor: UIColor, gradientColors: [CGColor], changeGradientColors: [CGColor]) {
        self.backGroundColor = backGroundColor
        self.gradientColors = gradientColors
        self.changeGradientColors = changeGradientColors
    }
    
    func instanceImageSet() -> [UIImage] {
        return [UIImage]()
    }
    
    func getImageByGaugeLevel(gaugeLevel: Int) -> UIImage? {
        if let images = images, !images.isEmpty {
            var newImage: UIImage
            let index = (gaugeLevel - 1) / Int(100 / images.count)
            
            if index < images.count {
                newImage = images[index]
            } else {
                newImage = images[images.count - 1]
            }
            return newImage
        } else {
            return nil
        }
    }
    
    // MARK: - By Level
    // gauge level is 1 ~ 100
    // 현재 로직에서 index는 gradientColor는 100을 기준으로 알맞게 나누어 떨어져야 에러가 없다...
    // 일단 index가 count를 벗어나면 에러처리는 해줌
    func getColorByGaugeLevel(gaugeLevel: Int) -> UIColor {
        let count = gradientColors.count
        let index = (gaugeLevel) / Int(100 / count) //gaugeLevel - 1 하면 비정상적인 에러 :TODO
        
        if index < count {
            let firstColor: UIColor = UIColor(cgColor: gradientColors[index])
            let secondColor: UIColor = UIColor(cgColor: changeGradientColors[index])
            let percentage: CGFloat = CGFloat((gaugeLevel % count) * 10)
            let newColor = firstColor.toColor(secondColor, percentage: percentage)
            
            return newColor
        } else {
            return UIColor(cgColor: gradientColors[count - 1])
        }
    }
}

class DefaultTheme: Theme {
    static let shared = DefaultTheme()
    let defaultBackgroudColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
    let defaultGradientColors: [CGColor] = [#colorLiteral(red: 0.947009027, green: 0.6707453132, blue: 0.8060829043, alpha: 1), #colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    let defaultChangedGColors: [CGColor] = [#colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    
    private init() {
        super.init(backGroundColor: defaultBackgroudColor,
                   gradientColors: defaultGradientColors,
                   changeGradientColors: defaultChangedGColors)
        images = instanceImageSet()
    }
    
    internal override func instanceImageSet() -> [UIImage] {
        let imageName = ["default_1", "default_2", "default_3", "default_4", "default_5", "default_6", "default_7", "default_8", "default_9", "default_10"]
        var imageSet = [UIImage]()
        
        for name in imageName {
            imageSet.append(UIImage(named: name)?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        }
        return imageSet
    }
}
