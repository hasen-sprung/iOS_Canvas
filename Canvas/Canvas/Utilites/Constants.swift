import UIKit

enum Const {
    enum Widget {
        static let configurationDisplayName: String = "꾸미기"
        static let description: String = "순간 순간의 감정을 기록해서 다양한 도형으로 캔버스를 채우세요"
    }
    
    enum Color {
        static let background = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        static let canvas = #colorLiteral(red: 0.9782244563, green: 0.9682950377, blue: 0.9425842166, alpha: 1)
    }
    
    enum MainView {
        static let countOfRecordViews: Int = 10
        static let overlapRatio: CGFloat = 0.7
    }
    
    enum SettingView {
        static let version: String = "버전"
    }
}

// MARK: - Auto-Layout
// 버튼 사이즈는 어떻게 관리해야 되지? 뷰별로 다 따로?? 아니면 통일성을 위해 전부 동일하게?
// 아님 뷰별로 컨스트를 다 따로만들고 얘는 다 하나로 관리를 해줘야하나???
let buttonSize = 40
let addButtonSize = 70
let paddingInSafeArea = 18
let infoHeight = 110
let iconSizeRatio = 0.7

let fontSize = 20
let textColor = UIColor(r: 72, g: 80, b: 84)
let defaultBackGroundColor = UIColor(r: 240, g: 240, b: 243)
