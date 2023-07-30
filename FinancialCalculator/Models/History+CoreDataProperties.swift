//
//  History+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var createddate: Date?
    @NSManaged public var historyamount: Double
    @NSManaged public var historyinterest: Double
    @NSManaged public var historypayment: Double
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var type: String?

}

extension History : Identifiable {

}
