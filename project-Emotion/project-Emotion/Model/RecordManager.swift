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
    
    
    func getMatchingRecords(currentDate: Date = DateManager.shared.getCurrentDate(),
                            currentMode: Int = DateManager.shared.getCurrentDateMode()) -> [Record] {

        var records = [Record]()
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let recordsRequest = Record.fetchRequest()
        
        if currentMode == 0 {
            
            let dateFrom = calendar.startOfDay(for: currentDate)
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            
            print("Date : ", dateFrom, " ~ ", dateTo!)
            
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Record.createdDate))
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            recordsRequest.predicate = datePredicate
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            return records
            
        } else if currentMode == 1 {
            
            let dateFrom = calendar.startOfDay(for: currentDate)
            let dateTo = calendar.date(byAdding: .day, value: 6, to: dateFrom)
            
            print("Date : ", dateFrom, " ~ ", dateTo!)
            
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Record.createdDate))
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            recordsRequest.predicate = datePredicate
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            return records
            
        } else if currentMode == 2 {
            
            let dateFrom = calendar.dateInterval(of: .month, for: currentDate)?.start
            let dateTo = calendar.date(byAdding: .month, value: 1, to: dateFrom!)
            
            print("Date : ", dateFrom!, " ~ ", dateTo!)
            
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom! as NSDate, #keyPath(Record.createdDate))
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Record.createdDate), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            recordsRequest.predicate = datePredicate
            do { records = try context.fetch(recordsRequest) } catch { print("context Error") }
            
            return records
        }
        
        return records
    }
    
    
}
