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
        
        let records = [
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
            (createdDate: Date(), gaugeLevel: 0.5, memo: "first"),
        ]
        
        
        for record in records {
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
            newRecord.createdDate = record.createdDate
            newRecord.gaugeLevel = Float(record.gaugeLevel)
            newRecord.memo = record.memo
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
