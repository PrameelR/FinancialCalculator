//
//  Mortgage+CoreDataClass.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData

@objc(Mortgage)
public class Mortgage: NSManagedObject {
    
    convenience init(loanamount: Double,interest: Double, payment: Double, numberofyears: Int16, insertIntomanagedObjectContext context: NSManagedObjectContext!) {
        self.init(context: context)
        self.loanamount = loanamount
        self.interest = interest
        self.payment = payment
        self.numberofyears = numberofyears
    }
    
}
