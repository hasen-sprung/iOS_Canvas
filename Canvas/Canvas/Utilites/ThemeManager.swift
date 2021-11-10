//
//  ThemeManager.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/10.
//

import UIKit

protocol ThemeProtocol {
    
}

class ThemeManager {
    static let shared = ThemeManager()
    private var userThemeValue = 0
    
    func setUserThemeValue(themeValue: Int) {
        userThemeValue = themeValue
    }
    
    private init() {}
    
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
    //    internal var color: Colors!
    //
    //    func getColor() -> Colors {
    //        return color
    //    }
    
    func instanceImageSet() -> [UIImage] {
        return [UIImage]()
    }
    
    // MARK: - 3가지의 그라데이션 색상을 추적하는 함수, 중간(0.5)을 기준으로 각각의 비율에 맞춰서 3 색상 사이의 값을 리턴해준다.
    //    func getCurrentColor(figure: Float) -> Int {
    //        let top = color.gauge.top
    //        let bot = color.gauge.bottom
    //        let mid = color.gauge.middle
    //
    //        if figure < 0.5 {
    //            return getColorToInt(color: top, secondColor: mid, figure: figure)
    //        } else {
    //            return getColorToInt(color: mid, secondColor: bot, figure: figure)
    //        }
    //    }
    
    //    internal func getColorToInt(color: UIColor, secondColor: UIColor, figure: Float) -> Int {
    //        let color = color.toColor(secondColor, percentage: CGFloat(figure / 2) * 100)
    //        let value = UInt(color.hexStringFromColor().dropFirst(2), radix: 16) ?? 0
    //        return Int(value)
    //    }
    
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

class DefaultTheme: Theme, ThemeProtocol  {
    static let shared = DefaultTheme()
    
    private override init() {
        super.init()
        //        setColor()
    }
    
    //    internal func setColor() {
    //        let gaugeColor = GaugeColor(top: cellGVTop, middle: cellGVMiddle, bottom: cellGVBottom)
    //        let viewColor = ViewColor(main: .black, gauge: cellGV)
    //        let shapeColor = ShapeColor(heart: defaultRed, circle: defaultYellow, triangle: defaultGreen, rectangle: defaultBlue, line: defaultPurple)
    //        color = Colors(gauge: gaugeColor, view: viewColor, shape: shapeColor)
    //    }
    //
    override func instanceImageSet() -> [UIImage] {
        
        let imageName = ["Image_1", "Image_2", "Image_3", "Image_4", "Image_5"]
        var imageSet = [UIImage]()
        
        for name in imageName {
            
            imageSet.append(UIImage(named: name)?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        }
        
        return imageSet
    }
    
    //    override func getCurrentColor(figure: Float) -> Int {
    //        if let heart = color.shape?.heart,
    //           let circle = color.shape?.circle,
    //           let triangle = color.shape?.triangle,
    //           let rectangle = color.shape?.rectangle,
    //           let line = color.shape?.line {
    //            switch figure {
    //            case 0.0...0.2:
    //                return getColorToInt(color: heart, secondColor: heart, figure: figure)
    //            case ...0.4:
    //                return getColorToInt(color: circle, secondColor: circle, figure: figure)
    //            case ...0.6:
    //                return getColorToInt(color: triangle, secondColor: triangle, figure: figure)
    //            case ...0.8:
    //                return getColorToInt(color: rectangle, secondColor: rectangle, figure: figure)
    //            default:
    //                return getColorToInt(color: line, secondColor: line, figure: figure)
    //            }
    //        } else {
    //            return 0
    //        }
    //    }
}

