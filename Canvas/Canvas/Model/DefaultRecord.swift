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
    
    static func savePosition() {
        let context = CoreDataStack.shared.managedObjectContext
        let request = DefaultPosition.fetchRequest()
        var positions: [DefaultPosition] = [DefaultPosition]()
        
        do {
            positions = try context.fetch(request)
        } catch { print("context Error") }
        for i in 0..<positions.count {
            if let x = DefaultRecord.data[i].x, let y = DefaultRecord.data[i].y {
                positions[i].xRatio = x
                positions[i].yRatio = y
            }
        }
        CoreDataStack.shared.saveContext()
    }
}

extension DefaultRecord {
    static let data: [DefaultRecord] = {
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
    "안녕하세요 :)", // 1
    "설정창에서 개발자에게 메일을 보낼 수 있습니다 :)", // 2
    "리스트에서 기록을 옆으로 밀면 삭제할 수 있어요!", // 3
    "도형을 누르면 그 순간을 추억할 수 있습니다.", // 4
    "작품 제목과 작가 이름은 설정창에서 변경 가능해요!", // 5
    "순간 순간의 감정을 기록해주세요 :)", // 6
    "흔들어서 도형을 섞는 옵션은 설정창에서 On/OFF 가 가능합니다!", // 7
    "흔들어보세요! 도형이 섞입니다.", // 8
    "작성한 기록은 리스트에서 모아볼 수 있고, 삭제할 수 있습니다.", // 9
    "게이지를 끝까지 올리면, 입력 작업이 취소됩니다.", // 10
]
