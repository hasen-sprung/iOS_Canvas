//
//  Calandar.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/10.
//

import Foundation

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
