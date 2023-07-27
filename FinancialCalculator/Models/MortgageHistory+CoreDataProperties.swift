//
//  MortgageHistory+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension MortgageHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MortgageHistory> {
        return NSFetchRequest<MortgageHistory>(entityName: "MortgageHistory")
    }

    @NSManaged public var mortageinterest: Double
    @NSManaged public var mortgageid: UUID?
    @NSManaged public var mortgageloanamount: Double
    @NSManaged public var mortgagenumberofyears: Int16
    @NSManaged public var mortgagepayment: Double

}
