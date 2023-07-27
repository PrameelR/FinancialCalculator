//
//  Mortgage+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//
//

import Foundation
import CoreData


extension Mortgage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mortgage> {
        return NSFetchRequest<Mortgage>(entityName: "Mortgage")
    }

    @NSManaged public var interest: Double
    @NSManaged public var loanamount: Double
    @NSManaged public var numberofyears: Int16
    @NSManaged public var payment: Double

}


extension Mortgage : Identifiable {

    
    func calculateMortgagePayment(numberOfYears: Int16, interest: Double, loanAmount: Double ) -> Double {
        let numberOfPayments = Double(numberOfYears) * 12.0
        let monthlyInterestRate = interest / 12.0 / 100.0
        let compoundRate = pow(1.0 + monthlyInterestRate, numberOfPayments)
        
        let mortgagePayment = loanAmount * (monthlyInterestRate * compoundRate) / (compoundRate - 1.0)
        return roundToTwoDecimalPlaces(mortgagePayment)
    }
    
    func calculateMortgagePrincipal(numberOfYears: Int16, interest: Double, payment: Double) -> Double {
        let numberOfPayments = Double(numberOfYears) * 12.0
        let monthlyInterestRate = interest / 12.0 / 100.0
        let compoundRate = pow(1.0 + monthlyInterestRate, numberOfPayments)
        
        let loanAmount = payment * (compoundRate - 1.0) / (monthlyInterestRate * compoundRate)
        return roundToTwoDecimalPlaces(loanAmount)
    }
    
    func calculateAnnualInterest(numberOfYears: Int16, payment: Double, loanAmount: Double) -> Double {
        if let interestRate = calculateInterestRate(mortgagePayment: payment, principal: loanAmount, loanTermInYears: Double(numberOfYears)) {
            return interestRate
        } else {
            return 0
        }
        
    }
    
    func calculateInterestRate(mortgagePayment: Double, principal: Double, loanTermInYears: Double) -> Double? {
        guard mortgagePayment > 0, principal > 0, loanTermInYears > 0 else {
            return nil
        }
        
        let numberOfPayments = loanTermInYears * 12.0
        
        var lowerBound = 0.0
        var upperBound = 1.0
        
        let tolerance = 0.00001
        var iterations = 0
        let maxIterations = 100
        
        while iterations < maxIterations {
            let mid = (lowerBound + upperBound) / 2
            
            let compoundRate = pow(1.0 + mid, numberOfPayments)
            
            let calculatedPayment = principal * (mid * compoundRate) / (compoundRate - 1.0)
            
            let error = mortgagePayment - calculatedPayment
            
            if abs(error) < tolerance {
                return mid * 12.0 * 100.0
            }
            
            if error > 0 {
                lowerBound = mid
            } else {
                upperBound = mid
            }
            
            iterations += 1
        }
        
        return nil
    }


    
    func calculateLoanTermInYears(payment: Double, interest: Double, loanAmount: Double) -> Int16 {
        guard payment > 0, interest > 0, loanAmount > 0 else {
            return 0
        }
        
        let monthlyInterestRate = interest / 12.0 / 100.0
        let termInMonths = log(payment / (payment - monthlyInterestRate * loanAmount)) / log(1 + monthlyInterestRate)
        let termInYears = termInMonths / 12.0
        if termInYears.isNaN {
            return 0
        }else{
            return Int16(ceil(termInYears))
        }
    }
}
