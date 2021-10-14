//
//  DataHelper.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/14.
//

import UIKit
import CoreData

class DataHelper {

    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func seedRecords() {
        
        for _ in 1 ... 100 {

            let userCalendar = Calendar.current
            var date = DateComponents()
            
            date.timeZone = NSTimeZone.local
            date.year = 2021
            date.month = Int.random(in: 9...10)
            date.day = Int.random(in: 1...30)
            date.hour = Int.random(in: 0...23)
            date.minute = Int.random(in: 0...59)
            date.second = Int.random(in: 0...59)
            
            let createdDate = userCalendar.date(from: date)
            let texts = ["Hello", "Hi", "Guten Tag", "Guten Morgen", "Gute Nacht", "Auf wiedersehen", "Tchüß", "chiao", "Hallo", "Willkommen", "mosi mosi", "ni-hao", "안녕", "다음에 또 봐", "bis bald",]
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
            newRecord.createdDate = createdDate
            newRecord.gaugeLevel = Float.random(in: 0.0...1.0)
            newRecord.memo = texts[Int.random(in: 0 ..< texts.count)]
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
