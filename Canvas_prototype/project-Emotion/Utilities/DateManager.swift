import UIKit

class DateManager {
    
    static let shared = DateManager()
    private init() { }
    
    private var currentDate = Date()
    private let dateFormat = DateFormatter()
    private var dateMode = 0 // 0 -> Day, 1 -> Week, 2 -> Month
    
    func initalizeDate() {
        
        currentDate = Date()
        dateMode = 0
    }
    
    func setToday() {
        currentDate = Date()
    }
    
    func getCurrentDate() -> Date {
        
        return currentDate
    }
    
    func getCurrentDateMode() -> Int {
        
        return dateMode
    }
    
    func changeDate(val: Int) {
        
        if dateMode == 0 {
            
            currentDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate) ?? Date()
            
        } else if dateMode == 1 {
            
            currentDate = Calendar.current.date(byAdding: .weekOfMonth, value: val, to: currentDate) ?? Date()
            
        } else if dateMode == 2 {
            
            currentDate = Calendar.current.date(byAdding: .month, value: val, to: currentDate) ?? Date()
        }
    }
    
    func getCurrentDateString() -> String {
        
        var dateString: String = ""
        
        if dateMode == 0 {
            
            dateFormat.dateFormat = "M월 d일"
            dateString = dateFormat.string(from: self.currentDate)
            return dateString
            
            
        } else if dateMode == 1 {
            
            currentDate = currentDate.startOfWeek()
            
            var tempDate = currentDate
            var tempDateString: String = ""
            
            tempDate = Calendar.current.date(byAdding: .day, value: 6, to: tempDate) ?? Date()
            dateFormat.dateFormat = "M월 d일"
            dateString = dateFormat.string(from: self.currentDate)
            tempDateString = dateFormat.string(from: tempDate)
            
            return dateString + " ~ " + tempDateString
            
        } else {
            
            dateFormat.dateFormat = "M월"
            dateString = dateFormat.string(from: self.currentDate)
            return dateString
            
        }
    }
    
    func setDateMode(newMode: Int) {
        
        if newMode == dateMode {
            return
        } else if newMode >= 0 && newMode <= 3 {
            setToday()
            dateMode = newMode
        } else {
            dateMode = 0
        }
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
extension Date {
    
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date ?? Date()
    }
    
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
}


class DateCount {
    
    private var date: String?
    private var count: Int?
    
    init() {
        date = ""
        count = 0
    }
    
    func getDate() -> String? {
        return date
    }
    
    func getCount() -> Int? {
        return count
    }
    
    func setDate(newDate: String?) {
        date = newDate
    }
    
    func setCount(newCount: Int?) {
        count = newCount
    }
}
