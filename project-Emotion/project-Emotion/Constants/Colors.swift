
import UIKit

// 기본 세포 테마 색상
struct ThemeColors {
    var gaugeViewBackgroundColor = UIColor(hex: 0xFFFCDB)
    var gaugeViewColorBottom = UIColor(hex: 0xA29FFF)
    var gaugeViewColorTop = UIColor(hex: 0xFFB5AF)
    var mainViewBackgroundColor = UIColor(hex: 0xA29FFF)
    var mainViewBackgroundSubColor = UIColor(hex: 0x706DD3)
}

// MARK: - 테마 클래스를 싱글톤으로 관리(?)
class Theme {
    static let shared = Theme()
    var colors: ThemeColors = ThemeColors()
    // SVG이미지 파일
    
    private init() {}
}

extension UIColor {
    // MARK: - 해당 색상까지의 중간 색들을 비율에 따라 가져오는 함수
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }
            
            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
    
    // MARK: - From UIColor to String
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "0x%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
    // MARK: - init(hex:)
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
