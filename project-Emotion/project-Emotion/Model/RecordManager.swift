//
//  RecordManager.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/11.
//

import UIKit
import CoreData

class RecordManager {
    
    
    static let shared = RecordManager()
    private init() { }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dateFormat = DateFormatter()

    
    
    func getMatchingRecords(currentDate: Date = DateManager.shared.getCurrentDate(),
                            currentMode: Int = DateManager.shared.getCurrentDateMode()) -> [Record] {
        
        var records = [Record]()
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let recordsRequest = Record.fetchRequest()
        
        if currentMode == 0 {
            
            let dateFrom = calendar.startOfDay(for: currentDate)
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            
            if let dateTo = dateTo {
                let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Record.createdDate))
                let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo as NSDate)
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
                recordsRequest.predicate = datePredicate
            }
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow < $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            return records
            
        } else if currentMode == 1 {
            
            let dateFrom = calendar.startOfDay(for: currentDate.startOfWeek())
            let dateTo = calendar.date(byAdding: .day, value: 6, to: dateFrom)
            
            if let dateTo = dateTo {
                let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Record.createdDate))
                let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo as NSDate)
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
                recordsRequest.predicate = datePredicate
            }
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow < $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            return records
            
        } else if currentMode == 2 {
            
            guard let dateFrom = calendar.dateInterval(of: .month, for: currentDate)?.start else { return records }
            
            let dateTo = calendar.date(byAdding: .month, value: 1, to: dateFrom)
            
            if let dateTo = dateTo {
                
                let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Record.createdDate))
                let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo as NSDate)
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
                recordsRequest.predicate = datePredicate
            }
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow < $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
            return records
        }
        
        return records
    }
    
    func getDateList(currentRecords: [Record]) -> [DateCount] {
        
        var dateCounts = [DateCount]()
        var lastDate = ""
        dateFormat.dateFormat = "M월 d일"
        
        for idx in 0 ..< currentRecords.count {
            
            let newDate = dateFormat.string(from: currentRecords[idx].createdDate ?? Date())
            if newDate != lastDate {
                let dateCount = DateCount()
                
                dateCount.setDate(newDate: newDate)
                
                let newCount = currentRecords.filter({dateFormat.string(from: $0.createdDate ?? Date()) == newDate}).count
                dateCount.setCount(newCount: newCount)
                lastDate = newDate
                dateCounts.append(dateCount)
            }
        }
        return dateCounts
    }
    
    func getLastRecords(userCount: Int) -> [Record]{
        
        var records = [Record]()
        var newRecord = [Record]()
        let recordsRequest = Record.fetchRequest()
        
        
        do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
        
        records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow < $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
        
        let recordCount = records.count
        
        if recordCount > userCount {
        
            for idx in recordCount - userCount ..< recordCount {
                
                newRecord.append(records[idx])
            }
        }
        
        return newRecord
    }
}
