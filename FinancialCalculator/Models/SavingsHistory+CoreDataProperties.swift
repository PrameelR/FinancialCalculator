//
//  SavingsHistory+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension SavingsHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingsHistory> {
        return NSFetchRequest<SavingsHistory>(entityName: "SavingsHistory")
    }

    @NSManaged public var savingscompoundperyear: Int16
    @NSManaged public var savingsfuturevalue: Double
    @NSManaged public var savingsid: UUID?
    @NSManaged public var savingsinterest: Double
    @NSManaged public var savingspayment: Double
    @NSManaged public var savingspaymentsperyear: Int16
    @NSManaged public var savingsprincipalamount: Double
    @NSManaged public var savingstotalnumberofpayments: Int16

}
