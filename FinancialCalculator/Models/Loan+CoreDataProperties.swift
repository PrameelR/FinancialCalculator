//
//  Loan+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension Loan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Loan> {
        return NSFetchRequest<Loan>(entityName: "Loan")
    }

    @NSManaged public var compoundperyear: Int16
    @NSManaged public var end: Bool
    @NSManaged public var futurevalue: Double
    @NSManaged public var interest: Double
    @NSManaged public var numberofpayments: Int16
    @NSManaged public var payment: Double
    @NSManaged public var presentvalue: Double

}

extension Loan : Identifiable {
    
    
       
    func calculateFutureValue(principalAmount P: Double, annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16, numberOfYears t: Int16,payment PMT: Double,isEnd end: Bool) -> Double
    {
        let a = Double(n * t)
        let b =  1 + ((r/100)/Double(n))
        var futureValue = pow(b,a) * P
        
        if(end != true)
        {
            futureValue += calculateStartFutureValue(a: a, b: b, annualInterestRate: r, compoundingPeriodsPerYear: n, payment: PMT)
        }
        else
        {
            futureValue += calculateEndFutureValue(a: a, b: b, annualInterestRate: r, compoundingPeriodsPerYear: n, payment: PMT)
        }
        return roundToTwoDecimalPlaces(futureValue)
    }
    
    func calculateStartFutureValue(a : Double, b : Double,annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16, payment PMT: Double) -> Double{
        return calculateEndFutureValue(a: a, b: b, annualInterestRate: r, compoundingPeriodsPerYear: n, payment: PMT) * b
    }
    
    func calculateEndFutureValue(a : Double, b : Double,  annualInterestRate r: Double, compoundingPeriodsPerYear n: Int16, payment PMT: Double) -> Double{
        return ( (pow(b,a) - 1)/((r/100.0) / Double(n))) * PMT
        
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
        if (numberOfYears.isNaN){
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
