//
//  CompoundLoanViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//

import UIKit
import CoreData

class CompoundLoanViewController: UIViewController, UITextFieldDelegate {
    
    var loan: Loan?
    @IBOutlet weak var viewSubStackContent: UIStackView!
    @IBOutlet weak var viewStackContent: UIStackView!
    @IBOutlet weak var viewScrollContent: UIScrollView!
    @IBOutlet weak var switchLoanEnd: UISwitch!
    @IBOutlet weak var txtLoanCompoundsPerYear: UITextField!
    @IBOutlet weak var txtLoanPaymentsPerYear: UITextField!
    @IBOutlet weak var txtLoanPayments: UITextField!
    @IBOutlet weak var txtLoanInterest: UITextField!
    @IBOutlet weak var txtLoanFutureValue: UITextField!
    @IBOutlet weak var txtLoanPresentValue: UITextField!
    @IBOutlet weak var tabMenuItemCompoundLoan: UITabBarItem!
    
    
    var context:NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtLoanPresentValue.delegate = self
        txtLoanFutureValue.delegate = self
        txtLoanInterest.delegate = self
        txtLoanPayments.delegate = self
        txtLoanPaymentsPerYear.delegate = self
        txtLoanCompoundsPerYear.delegate = self
        
        self.viewScrollContent.contentSize = CGSize(width: self.viewSubStackContent.bounds.width, height: self.viewSubStackContent.bounds.height)
        
        self.clearValues()
        self.loadLoanLastData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickbtnLoanClear(_ sender: Any) {
        
        self.truncateEntity()
        self.clearValues()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        calculateValues()
        if let text = textField.text {
            textField.text = removeThousandSeparators(from: text)
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) { 
        if let text = textField.text, let formattedText = addThousandSeparators(to: text) {
            textField.text = formattedText
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        var isValid: Bool = false;
        switch textField {
        case txtLoanPaymentsPerYear:
            isValid = validateWholeNumbersWithRange(textField,range,string,0,25)
        case txtLoanCompoundsPerYear:
            isValid = validateWholeNumbersWithRange(textField,range,string,0,25)
        case txtLoanPresentValue:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtLoanFutureValue:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtLoanInterest:
            isValid = validateDecimalNumbersWithRange(textField,range,string,2, 0,100)
        case txtLoanPayments:
            isValid = validateDecimalNumbers(textField,range,string,2)
        default:
            print("Validation done")
        }
        
        return isValid
    }
    
    
    @IBAction func changeEndSwitch(_ sender: Any) {
        self.calculateValues()
    }
    
    func clearValues(){
        txtLoanPresentValue.text = ""
        txtLoanFutureValue.text = ""
        txtLoanInterest.text = ""
        txtLoanPayments.text = ""
        txtLoanPaymentsPerYear.text = ""
        txtLoanCompoundsPerYear.text = ""
        switchLoanEnd.isOn = true
    }
    
    
    private func calculateValues(){
        
        if let loanobj = loan{
            
            loanobj.presentvalue = Double(removeThousandSeparators(from: txtLoanPresentValue.text ?? "0")) ?? 0
            loanobj.interest = Double(removeThousandSeparators(from: txtLoanInterest.text ?? "0")) ?? 0
            loanobj.payment = Double(removeThousandSeparators(from: txtLoanPayments.text ?? "0")) ?? 0
            loanobj.futurevalue = Double(removeThousandSeparators(from: txtLoanFutureValue.text ?? "0")) ?? 0
            loanobj.compoundperyear = Int16(removeThousandSeparators(from: txtLoanCompoundsPerYear.text ?? "0")) ?? 0
            loanobj.numberofpayments = Int16(removeThousandSeparators(from: txtLoanPaymentsPerYear.text ?? "0")) ?? 0
            loanobj.end = switchLoanEnd.isOn
        
            
            if (txtLoanFutureValue.text?.isEmpty ?? false || loanobj.futurevalue == 0) && txtLoanPresentValue.text?.isEmpty != true && txtLoanInterest.text?.isEmpty != true && txtLoanCompoundsPerYear.text?.isEmpty != true && txtLoanPaymentsPerYear.text?.isEmpty != true && txtLoanPayments.text?.isEmpty != true {
                loanobj.futurevalue = loanobj.calculateFutureValue(principalAmount: loanobj.presentvalue, annualInterestRate: loanobj.interest, compoundingPeriodsPerYear: loanobj.compoundperyear, numberOfYears: loanobj.numberofpayments, payment: loanobj.payment, isEnd: loanobj.end)
            }

            if (txtLoanPresentValue.text?.isEmpty ?? false || loanobj.presentvalue == 0) && txtLoanFutureValue.text?.isEmpty != true && txtLoanInterest.text?.isEmpty != true && txtLoanCompoundsPerYear.text?.isEmpty != true && txtLoanPaymentsPerYear.text?.isEmpty != true {
                loanobj.presentvalue = loanobj.calculatePrincipalAmount(FutureValue: loanobj.futurevalue, annualInterestRate: loanobj.interest, compoundingPeriodsPerYear: loanobj.compoundperyear, numberOfYears: loanobj.numberofpayments)
            }
            
            
            if (txtLoanPaymentsPerYear.text?.isEmpty ?? false || loanobj.numberofpayments == 0) && txtLoanFutureValue.text?.isEmpty != true && txtLoanPresentValue.text?.isEmpty != true && txtLoanInterest.text?.isEmpty != true && txtLoanCompoundsPerYear.text?.isEmpty != true {
                loanobj.numberofpayments = loanobj.calculateNumberOfPaymentsPerYears(FutureValue: loanobj.futurevalue, principalAmount: loanobj.presentvalue, annualInterestRate: loanobj.interest, compoundingPeriodsPerYear: loanobj.compoundperyear)
            }
            
            
            
            if (txtLoanInterest.text?.isEmpty ?? false || loanobj.interest == 0) && txtLoanFutureValue.text?.isEmpty != true && txtLoanPresentValue.text?.isEmpty != true && txtLoanCompoundsPerYear.text?.isEmpty != true && txtLoanPaymentsPerYear.text?.isEmpty != true {
                loanobj.interest = loanobj.calculateInterestRate(FutureValue: loanobj.futurevalue, principalAmount: loanobj.presentvalue, compoundingPeriodsPerYear: loanobj.compoundperyear,numberOfYears:loanobj.numberofpayments)
            }
            
           
            
            saveLoanLastData();
            
            txtLoanPresentValue.text = addThousandSeparators(to: String(loanobj.presentvalue))
            txtLoanInterest.text = addThousandSeparators(to: String(loanobj.interest))
            txtLoanPayments.text = addThousandSeparators(to: String(loanobj.payment))
            txtLoanFutureValue.text = addThousandSeparators(to: String(loanobj.futurevalue))
            txtLoanCompoundsPerYear.text = addThousandSeparators(to: String(loanobj.compoundperyear))
            txtLoanPaymentsPerYear.text = addThousandSeparators(to: String(loanobj.numberofpayments))
            switchLoanEnd.isOn = loanobj.end
            
        }else{
            loan = Loan.init(insertIntomanagedObjectContext: self.context)
            
            self.calculateValues()
        }
    }

    
    private func saveLoanLastData(){
        do{
            try self.context?.save()
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func loadLoanLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Loan")
        do{
            let loandetails = try self.context?.fetch(request) as! [Loan]
            if(loandetails.count>0){
                loan = loandetails[0]
                
                txtLoanPresentValue.text = addThousandSeparators(to: String(loandetails[0].presentvalue))
                txtLoanInterest.text = addThousandSeparators(to: String(loandetails[0].interest))
                txtLoanPayments.text = addThousandSeparators(to: String(loandetails[0].payment))
                txtLoanFutureValue.text = addThousandSeparators(to: String(loandetails[0].futurevalue))
                txtLoanPaymentsPerYear.text = addThousandSeparators(to: String(loandetails[0].numberofpayments))
                txtLoanCompoundsPerYear.text = addThousandSeparators(to: String(loandetails[0].compoundperyear))
                switchLoanEnd.isOn = loandetails[0].end
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    
    
    private func truncateEntity() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Loan")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context?.execute(batchDeleteRequest)

            // Save the managed object context to apply the changes to the persistent store
            try self.context?.save()

            print("All records in Loans have been deleted.")
        } catch {
            print("Error truncating Loans: \(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
