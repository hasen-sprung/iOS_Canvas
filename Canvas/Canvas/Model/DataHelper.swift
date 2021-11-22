import UIKit
import CoreData

class DataHelper {
    static let shared = DataHelper()
    
    private init() {}
    private let context = CoreDataStack.shared.managedObjectContext
    
    func loadSeeder() {
    
        let recordsRequest = Record.fetchRequest()
        let recordCount = try! context.fetch(recordsRequest)
        
        if  recordCount.count < 50 {
            self.seedRecords()
        }
    }

    private func seedRecords() {
        
        for _ in 1 ... 100 {

            let userCalendar = Calendar.current
            var date = DateComponents()
            
            date.timeZone = NSTimeZone.local
            date.year = 2021
            date.month = Int.random(in: 9...11)
            if date.month ?? 1 <= 10 {
                date.day = Int.random(in: 1...31)
            }
            else {
                date.day = Int.random(in: 1...22)
            }
            date.hour = Int.random(in: 0...23)
            date.minute = Int.random(in: 0...59)
            date.second = Int.random(in: 0...59)
            
            let createdDate = userCalendar.date(from: date)
            let texts = ["죽는 날까지 하늘을 우러러 한 점 부끄럼이 없기를 잎새에 이는 바람에도 나는 괴로워했다",
                        "별은 노래하는 마음으로 모든 죽어가는 것을 사랑해야지 그리고 나한테 주어진 길을 걸어야겠다",
                         "우리들은 모두 무엇이 되고 싶다 너는 나에게 나는 너에게 잊혀지지 않는 하나의 눈짓이 되고 싶다",
                         "우리가 눈발이라면 허공에서 쭈빗쭈빗 흩날리는 진눈깨비는 되지 말자",
                         "세상이 바람 불고 춥고 어둡다 해도 사람이 사는 마을 가장 낮은 곳으로 따뜻한 함박눈이 되어 내리자",
                         "다시 우러러보는 이 하늘에 겨울밤 달이 아직도 차거니 오는 봄엔 분수처럼 쏟아지는 태양을 안고 그 어느 언덕 꽃덤불에 아늑히 안겨보리라",
                         "까닭없이 마음 외로울 때는 노오란 민들레꽃 한 송이도 애처롭게 그리워지는데 아 얼마나 한 위로이랴 소리쳐 부를 수도 없는 이 아득한 거리에 그대 조용히 나를 찾아오느니",
                         "숨죽여 흐느끼며 네 이름을 남 몰래 쓴다 타는 목마름으로 타는 목마름으로 민주주의여 만세",
                         "오늘은 단 한 사람을 위해서라도 좋으니 누군가 기뻐할 만한 일을 하고 싶다",
                         "그리운 날은 그림을 그리고 쓸쓸한 날은 음악을 들었다 그리고도 남는 날은 너를 생각해야만 했다",
                         "사람들에게도 꽃처럼 향기가 있다는 걸 새롭게 배우기 시작하지.",
                         "아무도 반달을 사랑하지 않는다면 반달이 보름달이 될 수 있겠는가 보름달이 반달이 되지 않는다면 사랑은 그 얼마나 오만할 것인가",
                         "달팽이와 함께! 달팽이는 움직이지 않는다 다만 도달할 뿐이다",
                         "먹지는 못하고 바라만 보다가 바라만 보며 향기만 맡다 충치처럼 꺼멓게 썩어버리는 그런 첫사랑이 내게도 있었다",
                         "짧다고 말하지 마라 눈물이 적다고 눈물샘이 작으랴",
                         "그 사막에서 그는 너무도 외로워 때로는 뒷걸음질로 걸었다 자기 앞에 찍힌 발자국을 보려고",
                         "내 귀는 소라껍질 바다 소리를 그리워한다",
                         "어여쁘신 그대는 내내 어여쁘소서",
                         "그래, 내가 낮은 곳에 있겠다는 건 너를 위해 나를 온전히 비우겠다는 뜻이다.",
                         "가끔 네 꿈을 꾼다 전에는 꿈이라도 꿈인 줄 모르겠더니 이제는 너를 보면 아, 꿈이로구나 알아챈다",
                         "낮은 곳에 있고 싶었다. 낮은 곳이라면 지상의 그 어디라도 좋다.",
                         "목숨의 처음과 끝 천국에서 지옥까지 가고 싶었다. 맨발로 너와 함께 타오르고 싶었다. 죽고 싶었다.",
                         "꿈결인 듯 들리는 소리 있어 그대 발걸음 소리인가 하겠습니다",
                         "그대 돌아오는 길 역시 다시 떠나기 위한 길임을 아는가",
                         "너를 생각할 때마다 언덕 너머 안개처럼 피어나는 그리움 넋 놓은 별 밭이다 비 오는 날은",
                         "그 슬픔의 바닥에 들어간 적이 있다. 안 보이는 하늘이 후두둑 빗방울로 떨어지며 덫에 걸린 듯 퍼덕였다.",
                         "그대 가슴에는 두레박 줄을 아무리 풀어내려도 닿을 수 없는 미세한 슬픔이 시커먼 이무기처럼 묵어서 사는 밑바닥이 있다."
            ]
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
            newRecord.createdDate = createdDate
            newRecord.gaugeLevel = Int16.random(in: 1...100)
            newRecord.memo = texts[Int.random(in: 0 ..< texts.count)]
            newRecord.setPosition = nil
        }
        
        CoreDataStack.shared.saveContext()
    }
}
