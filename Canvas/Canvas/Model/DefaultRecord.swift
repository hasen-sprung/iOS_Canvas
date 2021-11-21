import Foundation

class DefaultRecord {
    var gaugeLevel: Int16
    var createDate: Date
    var memo: String?
    var x: Float?
    var y: Float?
    
    init(gaugeLevel: Int16 = 1, createDate: Date = Date()) {
        self.gaugeLevel = gaugeLevel
        self.createDate = createDate
    }
}

extension DefaultRecord {
    static let records: [DefaultRecord] = {
        var records = [DefaultRecord]()
        
        for i in 0..<10 {
            var record = DefaultRecord()
            
            record.gaugeLevel = Int16(10 * (i + 1))
            record.memo = DefaultTexts[i]
            records.append(record)
        }
        return records
    }()
}

fileprivate let DefaultTexts: [String] = [
    "+를 눌러라", // 1
    "어서와", // 2
    "게이지를 맨 위에서 무슨일이 일어날까?", // 3
    "감사합니다", // 4
    "+ 버튼으로 새로운 감정을 기록하세요", // 5
    
    "좋아요를 눌러주세요", // 6
    "Hello World", // 7
    "어서오세요", // 8
    "물결을 끝까지 올리면 어떻게 될까요?", // 9
    "아이폰을 흔들어보세요!", // 10
]
