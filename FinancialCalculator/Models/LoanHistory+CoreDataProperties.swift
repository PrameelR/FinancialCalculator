//
//  LoanHistory+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension LoanHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanHistory> {
        return NSFetchRequest<LoanHistory>(entityName: "LoanHistory")
    }

    @NSManaged public var loancompoundsperyear: Int16
    @NSManaged public var loanend: Bool
    @NSManaged public var loanfuturevalue: Double
    @NSManaged public var loanid: UUID?
    @NSManaged public var loaninterest: Double
    @NSManaged public var loannumberofpayments: Int16
    @NSManaged public var loanpayment: Double
    @NSManaged public var loanpresentvalue: Double

}
