//
//  DateManager.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/10.
//

import UIKit

enum DateMode: Int {
    case day = 0
    case week = 1
    case month = 2
}

class DateManager {
    
    static let shared = DateManager()
    private init() { }
    
    private var currentDate = Date()
    private let dateFormat = DateFormatter()
    private var dateMode = DateMode.day
    func initalizeDate() {
        
        currentDate = Date()
        dateMode = DateMode.day
    }
    
    func setDateToToday() {
        currentDate = Date()
    }
    
    func getCurrentDate() -> Date {
        
        return currentDate
    }
    
    func getCurrentDateMode() -> DateMode {
        
        return dateMode
    }
    
    func changeDate(val: Int) {
        
        if dateMode == DateMode.day {
            
            currentDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate) ?? Date()
            
        } else if dateMode == DateMode.day {
            
            currentDate = Calendar.current.date(byAdding: .weekOfMonth, value: val, to: currentDate) ?? Date()
            
        } else if dateMode == DateMode.day {
            
            currentDate = Calendar.current.date(byAdding: .month, value: val, to: currentDate) ?? Date()
        }
    }
    
    func getCurrentDateString() -> String {
        
        var dateString: String = ""
        
        if dateMode == DateMode.day {
            
            dateFormat.dateFormat = "M월 d일"
            dateString = dateFormat.string(from: self.currentDate)
            return dateString
            
            
        } else if dateMode == DateMode.week {
            
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
