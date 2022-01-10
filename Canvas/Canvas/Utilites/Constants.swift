import UIKit

enum Const {
    enum Widget {
        static let configurationDisplayName: String = "꾸미기"
        static let description: String = "순간 순간의 감정을 기록해서 다양한 도형으로 캔버스를 채우세요"
    }
    
    enum Color {
        static let background = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        static let canvas = #colorLiteral(red: 0.9782244563, green: 0.9682950377, blue: 0.9425842166, alpha: 1)
        static let textLabel = UIColor(r: 72, g: 80, b: 84)
    }
    
    enum MainView {
        static let countOfRecordViews: Int = 10
        static let overlapRatio: CGFloat = 0.7
    }
    
    enum SettingView {
        static let version: String = "버전"
    }
    
    enum FontSize {
       static let label = 20
    }
    
    // MARK: - Auto Layout Constraints
    enum Constraints {
        static let buttonSize = 40
        static let addButtonSize = 70
        static let paddingInSafeArea = 18
        static let infoHeight = 110
        static let iconSizeRatio = 0.7
    }
}
