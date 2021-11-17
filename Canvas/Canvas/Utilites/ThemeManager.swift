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

    init(backGroundColor: UIColor, gradientColors: [CGColor], changeGradientColors: [CGColor]) {
        self.backGroundColor = backGroundColor
        self.gradientColors = gradientColors
        self.changeGradientColors = changeGradientColors
    }
    
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
    
    // gauge level is 1 ~ 100
    func getColorByGaugeLevel(gaugeLevel: Int) -> UIColor {
        var color: UIColor
        let count = gradientColors.count
        let index = gaugeLevel / count
        
        if index < count {
            let firstColor: UIColor = UIColor(cgColor: gradientColors[index])
            let secondColor: UIColor = UIColor(cgColor: changeGradientColors[index])
            let percentage: CGFloat = CGFloat((gaugeLevel % count) * 10)
            let newcolor = firstColor.toColor(secondColor, percentage: percentage)
            
            color = newcolor
        } else {
            color = UIColor(cgColor: gradientColors[count - 1])
        }
        return color
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
