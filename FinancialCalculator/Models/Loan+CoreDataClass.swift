//
//  Loan+CoreDataClass.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData

@objc(Loan)
public class Loan: NSManagedObject {

    convenience init(insertIntomanagedObjectContext context: NSManagedObjectContext!) {
        self.init(context: context)
    }
}
