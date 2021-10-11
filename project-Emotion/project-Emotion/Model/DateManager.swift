//
//  DateManager.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/10.
//

import UIKit

class DateManager {
    
    static let shared = DateManager()
    private init() { }
    
    private var currentDate = Date()
    private let dateFormat = DateFormatter()
    private var dateMode = 0 // 0 -> Day, 1 -> Week, 2 -> Month
    
    func getCurrentDate() -> Date {
        
        return currentDate
    }
    
    func getCurrentDateMode() -> Int {
        
        return dateMode
    }
    
    func moveDate(val: Int) {
        
        if dateMode == 0 {
            
            currentDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)!
            
        } else if dateMode == 1 {
            
            currentDate = Calendar.current.date(byAdding: .weekOfMonth, value: val, to: currentDate)!
            
        } else if dateMode == 2 {
            
            currentDate = Calendar.current.date(byAdding: .month, value: val, to: currentDate)!
        }
    }
    
    func getCurrentDateString() -> String {
        
        let dateString: String!
        
        if dateMode == 0 {
            
            dateFormat.dateFormat = "M월 d일"
            dateString = dateFormat.string(from: self.currentDate)
            return dateString
            
            
        } else if dateMode == 1 {
            
            currentDate = currentDate.startOfWeek()
            
            var tempDate = currentDate
            var tempDateString: String!
            
            tempDate = Calendar.current.date(byAdding: .day, value: 6, to: tempDate)!
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
        
        if newMode >= 0 && newMode <= 3 {
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
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}
