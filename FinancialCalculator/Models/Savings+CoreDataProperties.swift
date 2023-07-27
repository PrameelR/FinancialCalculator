//
//  Savings+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension Savings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Savings> {
        return NSFetchRequest<Savings>(entityName: "Savings")
    }

    @NSManaged public var compoundperyear: Int16
    @NSManaged public var futurevalue: Double
    @NSManaged public var interest: Double
    @NSManaged public var payments: Double
    @NSManaged public var paymentsperyear: Int16
    @NSManaged public var principalamount: Double
    @NSManaged public var totalnumberofpayments: Int16

}

extension Savings : Identifiable {
    
    func calculateFutureValue(principalAmount P: Double, annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16, numberOfYears t: Int16) -> Double {
        let ratePerPeriod = (r/100) / Double(n)
        let numberOfPeriods = Double(n * t)
        let compoundFactor = pow(1 + ratePerPeriod, numberOfPeriods)
        let futureValue = P * compoundFactor
        return roundToTwoDecimalPlaces(futureValue)
    }
    
    func calculatePrincipalAmount(FutureValue A: Double, annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16, numberOfYears t: Int16) -> Double {
        let ratePerPeriod = (r/100) / Double(n)
        let numberOfPeriods = Double(n * t)
        let compoundFactor = pow(1 + ratePerPeriod, numberOfPeriods)
        let principalAmount = A / compoundFactor
        return roundToTwoDecimalPlaces(principalAmount)
    }
    
    
    
    func calculateNumberOfPaymentsPerYears(FutureValue A: Double, principalAmount P: Double, annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16) -> Int16 {
        let ratePerPeriod = (r/100) / Double(n)
        let logarithmValue = log(A / P)
        let denominator = abs(log(1 + ratePerPeriod))
        let numberOfYears = logarithmValue / (Double(n) * denominator)
        if(numberOfYears.isNaN){
            return 0
        }else{
            return Int16(ceil(numberOfYears))
        }
    }
    
    func calculateInterestRate(FutureValue A: Double, principalAmount P: Double, compoundingPeriodsPerYear n: Int16, numberOfYears t: Int16) -> Double {
        guard P > 0, A > 0, n > 0, t > 0 else {
            return 0 // Invalid input, return nil
        }
        
        let base = A / P
        let exponent = 1.0 / (Double(n) * Double(t))
        let term = pow(base, exponent)
        let rate = Double(n) * (term - 1)
        return abs(rate) * 100
    }
    
}
