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
    "게이지를 맨 위에서 놓으면?", // 3
    "", // 4
    "", // 5
    
    "", // 6
    "", // 7
    "", // 8
    "", // 9
    "", // 10
]
