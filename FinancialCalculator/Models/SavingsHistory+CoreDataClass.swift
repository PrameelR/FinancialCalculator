//
//  SavingsHistory+CoreDataClass.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData

@objc(SavingsHistory)
public class SavingsHistory: History {

    convenience init(insertIntomanagedObjectContext context: NSManagedObjectContext!) {
        self.init(context: context)
    }
}
