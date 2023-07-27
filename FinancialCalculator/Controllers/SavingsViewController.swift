//
//  SavingsViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//

import UIKit
import CoreData

class SavingsViewController: UIViewController, UITextFieldDelegate {
    
    
    var saving: Savings?
    @IBOutlet weak var viewSubStackContent: UIStackView!
    @IBOutlet weak var viewStackContent: UIStackView!
    @IBOutlet weak var viewScolllContent: UIScrollView!
    @IBOutlet weak var txtSavingsNumberOfPayments: UITextField!
    @IBOutlet weak var txtSavingsFutureValue: UITextField!
    @IBOutlet weak var txtSavingsPaymentsPerYear: UITextField!
    @IBOutlet weak var txtSavingsCompoundsPerYear: UITextField!
    @IBOutlet weak var txtSavingsPayments: UITextField!
    @IBOutlet weak var txtSavingsInterest: UITextField!
    @IBOutlet weak var txtSavingsPrincipalAmount: UITextField!
    @IBOutlet weak var tabMenuItemSavings: UITabBarItem!
    
    
    var context:NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtSavingsPrincipalAmount.delegate = self
        txtSavingsInterest.delegate = self
        txtSavingsPayments.delegate = self
        txtSavingsCompoundsPerYear.delegate = self
        txtSavingsPaymentsPerYear.delegate = self
        txtSavingsFutureValue.delegate = self
        txtSavingsNumberOfPayments.delegate = self
        
        self.viewScolllContent.contentSize = CGSize(width: self.viewSubStackContent.bounds.width, height: self.viewSubStackContent.bounds.height)
        
        self.clearValues()
        self.loadSavingsLastData()
    }
    
    
    @IBAction func clickbtnSavingsClear(_ sender: Any) {
        self.truncateEntity()
        self.clearValues()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = removeThousandSeparators(from: text)
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.calculateValues()
        if let text = textField.text, let formattedText = addThousandSeparators(to: text) {
            textField.text = formattedText
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        var isValid: Bool = false;
        switch textField {
        case txtSavingsPrincipalAmount:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtSavingsPayments:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtSavingsFutureValue:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtSavingsInterest:
            isValid = validateDecimalNumbersWithRange(textField,range,string,2, 0,100)
        case txtSavingsPaymentsPerYear:
            isValid = validateWholeNumbersWithRange(textField, range, string, 0, 25)
        case txtSavingsCompoundsPerYear:
            isValid = validateWholeNumbersWithRange(textField, range, string, 0, 25)
        case txtSavingsNumberOfPayments:
            isValid = validateWholeNumbersWithRange(textField, range, string, 0, 300)
        case txtSavingsPayments:
            isValid = validateDecimalNumbersWithRange(textField,range,string,2, 0,100)
        default:
            print("Validation done")
        }
        
        return isValid
    }
    
    private func clearValues (){
        
        txtSavingsPrincipalAmount.text = ""
        txtSavingsInterest.text = ""
        txtSavingsPayments.text = ""
        txtSavingsFutureValue.text = ""
        txtSavingsCompoundsPerYear.text = ""
        txtSavingsNumberOfPayments.text = ""
        txtSavingsPaymentsPerYear.text = ""
    }
    
    private func calculateValues(){
        
        if let savingsobj = saving{
            
            savingsobj.principalamount = Double(removeThousandSeparators(from: txtSavingsPrincipalAmount.text ?? "0")) ?? 0
            savingsobj.interest = Double(removeThousandSeparators(from: txtSavingsInterest.text ?? "0")) ?? 0
            savingsobj.payments = Double(removeThousandSeparators(from: txtSavingsPayments.text ?? "0")) ?? 0
            savingsobj.futurevalue = Double(removeThousandSeparators(from: txtSavingsFutureValue.text ?? "0")) ?? 0
            savingsobj.compoundperyear = Int16(removeThousandSeparators(from: txtSavingsCompoundsPerYear.text ?? "0")) ?? 0
            savingsobj.paymentsperyear = Int16(removeThousandSeparators(from: txtSavingsPaymentsPerYear.text ?? "0")) ?? 0
            savingsobj.totalnumberofpayments = Int16(removeThousandSeparators(from: txtSavingsNumberOfPayments.text ?? "0")) ?? 0
            
            if (txtSavingsFutureValue.text?.isEmpty ?? false || savingsobj.futurevalue == 0) && txtSavingsPrincipalAmount.text?.isEmpty != true && txtSavingsInterest.text?.isEmpty != true && txtSavingsCompoundsPerYear.text?.isEmpty != true && txtSavingsNumberOfPayments.text?.isEmpty != true {
                savingsobj.futurevalue = savingsobj.calculateFutureValue(principalAmount: savingsobj.principalamount, annualInterestRate: savingsobj.interest, compoundingPeriodsPerYear: savingsobj.compoundperyear, numberOfYears: savingsobj.paymentsperyear)
            }
            
            
            if (txtSavingsPrincipalAmount.text?.isEmpty ?? false || savingsobj.principalamount == 0) && txtSavingsFutureValue.text?.isEmpty != true && txtSavingsInterest.text?.isEmpty != true && txtSavingsCompoundsPerYear.text?.isEmpty != true && txtSavingsNumberOfPayments.text?.isEmpty != true {
                savingsobj.principalamount = savingsobj.calculatePrincipalAmount(FutureValue: savingsobj.futurevalue, annualInterestRate: savingsobj.interest, compoundingPeriodsPerYear: savingsobj.compoundperyear, numberOfYears: savingsobj.paymentsperyear)
            }
            
            
            if (txtSavingsPaymentsPerYear.text?.isEmpty ?? false || savingsobj.paymentsperyear == 0) && txtSavingsFutureValue.text?.isEmpty != true && txtSavingsPrincipalAmount.text?.isEmpty != true && txtSavingsInterest.text?.isEmpty != true && txtSavingsCompoundsPerYear.text?.isEmpty != true {
                savingsobj.paymentsperyear = savingsobj.calculateNumberOfPaymentsPerYears(FutureValue: savingsobj.futurevalue, principalAmount: savingsobj.principalamount, annualInterestRate: savingsobj.interest, compoundingPeriodsPerYear: savingsobj.compoundperyear)
            }
            
            
            
            if (txtSavingsInterest.text?.isEmpty ?? false || savingsobj.interest == 0) && txtSavingsFutureValue.text?.isEmpty != true && txtSavingsPrincipalAmount.text?.isEmpty != true && txtSavingsPaymentsPerYear.text?.isEmpty != true && txtSavingsCompoundsPerYear.text?.isEmpty != true {
                savingsobj.interest = savingsobj.calculateInterestRate(FutureValue: savingsobj.futurevalue, principalAmount: savingsobj.principalamount, compoundingPeriodsPerYear: savingsobj.compoundperyear,numberOfYears: savingsobj.paymentsperyear)
            }
            
           
            
            saveSavingsLastData();
            
            txtSavingsPrincipalAmount.text = addThousandSeparators(to: String(savingsobj.principalamount))
            txtSavingsInterest.text = addThousandSeparators(to: String(savingsobj.interest))
            txtSavingsPayments.text = addThousandSeparators(to: String(savingsobj.payments))
            txtSavingsFutureValue.text = addThousandSeparators(to: String(savingsobj.futurevalue))
            txtSavingsCompoundsPerYear.text = addThousandSeparators(to: String(savingsobj.compoundperyear))
            txtSavingsPaymentsPerYear.text = addThousandSeparators(to: String(savingsobj.paymentsperyear))
            txtSavingsNumberOfPayments.text = addThousandSeparators(to: String(savingsobj.totalnumberofpayments))
            
        }else{
            saving = Savings.init(insertIntomanagedObjectContext: self.context)
            
            self.calculateValues()
        }
    }

    
    private func saveSavingsLastData(){
        do{
            try self.context?.save()
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func loadSavingsLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Savings")
        do{
            let savingsdetails = try self.context?.fetch(request) as! [Savings]
            if(savingsdetails.count>0){
                saving = savingsdetails[0]
                
                txtSavingsPrincipalAmount.text = addThousandSeparators(to: String(savingsdetails[0].principalamount))
                txtSavingsInterest.text = addThousandSeparators(to: String(savingsdetails[0].interest))
                txtSavingsPayments.text = addThousandSeparators(to: String(savingsdetails[0].payments))
                txtSavingsFutureValue.text = addThousandSeparators(to: String(savingsdetails[0].futurevalue))
                txtSavingsPaymentsPerYear.text = addThousandSeparators(to: String(savingsdetails[0].paymentsperyear))
                txtSavingsCompoundsPerYear.text = addThousandSeparators(to: String(savingsdetails[0].compoundperyear))
                txtSavingsNumberOfPayments.text = addThousandSeparators(to: String(savingsdetails[0].totalnumberofpayments))
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    private func truncateEntity() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Savings")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context?.execute(batchDeleteRequest)

            // Save the managed object context to apply the changes to the persistent store
            try self.context?.save()

            print("All records in Savings have been deleted.")
        } catch {
            print("Error truncating Savings: \(error)")
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
