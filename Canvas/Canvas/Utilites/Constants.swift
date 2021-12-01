import UIKit

// MARK: - UP & Down
let up: Bool = true
let down: Bool = false

// MARK: - Gradient Colors
let bgColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
let canvasColor = #colorLiteral(red: 0.9782244563, green: 0.9682950377, blue: 0.9425842166, alpha: 1)

// MARK: - Default Value
let defaultCountOfRecordInCanvas: Int = 10

// MARK: - Widget Description
let widgetDisplayName: String = "꾸미기"
let widgetDescription: String = "순간 순간의 감정을 기록해서 다양한 도형으로 캔버스를 채우세요"

// MARK: - Auto-Layout
let buttonSize = 40
let addButtonSize = 70
let paddingInSafeArea = 18
let infoHeight = 110
let iconSizeRatio = 0.7

let fontSize = 20
let textColor = UIColor(r: 72, g: 80, b: 84)

// MARK: - TEXT
// - MAIN VIEW
let recordViewOverlapRatio: CGFloat = 0.7

// - GAUGE VIEW

// - LIST VIEW

// - SETTING
let textSettingVersion = "버전"

let greetingMessages = ["\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님! 어떤 하루를 보내고 계시나요?\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!",
                        "좋은 하루에요! \(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n틈틈히 느끼는 생각을 기록하시면서\n나만의 그림을 완성해보세요!",
                        "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님 오늘 날씨는 어떤가요?\n사소한 것도 기록 하다 보면\n소중한 추억이 쌓이게 될거에요!",
                        "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님은 기록만 열심히 하세요!\n저희는 앞으로 많은 작가들과 함께\n예쁜 기록을 만들어드릴게요!",
                        "\(UserDefaults.shared.string(forKey: "userID") ?? "무명작가")님!\n오늘 밤 잠들기 전에\n작성한 기록들을 읽어보시는건 어때요?"]
