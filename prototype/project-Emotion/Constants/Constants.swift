
import Foundation
import UIKit

// MARK: - Theme Color
let userDefaultColor: String = "ThemeColor"

let defaultColor: Int = 0
let customColor: Int = 1
let seoulColor: Int = 2

// MARK: - Safe Area Ratio
let safeAreaRatio: Float = 0.2
let cancelAreaRatio: Float = 0.1

// ??: constants로 hex를 string으로 잡아놓고 컨버트해서 사용 vs UIColors를 Constants로 사용
// 개인적인 생각은 UIColor로 상수화하는게 연산을 한번 줄여줘서 더 빠르지만 용량을 많이 차지할거 같다.

let red900: UIColor = UIColor(hex: 0xB71C1C)
let red500: UIColor = UIColor(hex: 0xF44336)
let red100: UIColor = UIColor(hex: 0xFFCDD2)

let pink900: UIColor = UIColor(hex: 0x880E4F)
let pink500: UIColor = UIColor(hex: 0xE91E63)
let pink100: UIColor = UIColor(hex: 0xF8BBD0)

let indigo900: UIColor = UIColor(hex: 0x1A237E)
let indigo500: UIColor = UIColor(hex: 0x3F51B5)
let indigo100: UIColor = UIColor(hex: 0xC5CAE9)

// MARK: - Cell Theme Colors
let cellGVTop: UIColor = UIColor(hex: 0xFCFFB9)
let cellGVMiddle: UIColor = UIColor(hex: 0xFFB5AF)
let cellGVBottom: UIColor = UIColor(hex: 0xA29FFF)
let cellGV: UIColor = UIColor(hex: 0xFFFEF0)
let cellMV: UIColor = UIColor(hex: 0xFFFEF0)

// MARK: - Default Colors
let defaultRed: UIColor = UIColor(hex: 0xB23020)
let defaultYellow: UIColor = UIColor(hex: 0xEBC96E)
let defaultGreen: UIColor = UIColor(hex: 0x6BC1B1)
let defaultBlue: UIColor = UIColor(hex: 0x557CCF)
let defaultPurple: UIColor = UIColor(hex: 0x9D28F1)
