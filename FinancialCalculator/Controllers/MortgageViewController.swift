//
//  MortgageViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//

import UIKit
import CoreData

class MortgageViewController: UIViewController, UITextFieldDelegate {

    var mortgage: Mortgage?
    @IBOutlet weak var txtMortgageNumberofYears: UITextField!
    @IBOutlet weak var txtMortgagePayment: UITextField!
    @IBOutlet weak var txtMortgageInterest: UITextField!
    @IBOutlet weak var txtMortgageLoanAmmount: UITextField!
    @IBOutlet weak var tabMenuItemMortage: UITabBarItem!
    
    
    var context:NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtMortgageLoanAmmount.delegate = self
        txtMortgageInterest.delegate = self
        txtMortgagePayment.delegate = self
        txtMortgageNumberofYears.delegate = self
        
        
        txtMortgagePayment.clearButtonMode = .whileEditing
        txtMortgageInterest.clearButtonMode = .whileEditing
        txtMortgageLoanAmmount.clearButtonMode = .whileEditing
        txtMortgageNumberofYears.clearButtonMode = .whileEditing
        
        self.clearValues()
        self.loadMortgageLastData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickbtnMortgageClear(_ sender: Any) {
        self.truncateEntity()
        self.clearValues()
    }
    
    @IBAction func clickbtnMortgageCalculate(_ sender: Any) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = removeThousandSeparators(from: text)
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.calculateValues();
        if let text = textField.text, let formattedText = addThousandSeparators(to: text) {
            textField.text = formattedText
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        var isValid: Bool = false;
        switch textField {
        case txtMortgageNumberofYears:
            isValid = validateWholeNumbersWithRange(textField,range,string,0,1000)
        case txtMortgageLoanAmmount:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtMortgagePayment:
            isValid = validateDecimalNumbers(textField,range,string,2)
        case txtMortgageInterest:
           isValid = validateDecimalNumbersWithRange(textField,range,string,2, 0,100)
        default:
            print("Validation done")
        }
        
        return isValid
    }
    
    private func clearValues(){
        txtMortgageLoanAmmount.text = ""
        txtMortgagePayment.text = ""
        txtMortgageInterest.text = ""
        txtMortgageNumberofYears.text = ""
    }
    
    private func calculateValues(){
        
        if let mortgageobj = mortgage{
            
            mortgageobj.loanamount = Double(removeThousandSeparators(from: txtMortgageLoanAmmount.text ?? "0")) ?? 0
            mortgageobj.interest = Double(removeThousandSeparators(from: txtMortgageInterest.text ?? "0")) ?? 0
            mortgageobj.payment = Double(removeThousandSeparators(from: txtMortgagePayment.text ?? "0")) ?? 0
            mortgageobj.numberofyears = Int16(removeThousandSeparators(from: txtMortgageNumberofYears.text ?? "0")) ?? 0
            
            if (txtMortgageLoanAmmount.text?.isEmpty ?? false || mortgageobj.loanamount == 0) && txtMortgageInterest.text?.isEmpty != true && txtMortgagePayment.text?.isEmpty != true && txtMortgageNumberofYears.text?.isEmpty != true {
                mortgageobj.loanamount = mortgageobj.calculateMortgagePrincipal(numberOfYears: mortgageobj.numberofyears, interest: mortgageobj.interest, payment: mortgageobj.payment)
            }
            if (txtMortgageInterest.text?.isEmpty ?? false || mortgageobj.interest == 0) && txtMortgageLoanAmmount.text?.isEmpty != true && txtMortgagePayment.text?.isEmpty != true && txtMortgageNumberofYears.text?.isEmpty != true {
                mortgageobj.interest = mortgageobj.calculateAnnualInterest(numberOfYears: mortgageobj.numberofyears, payment: mortgageobj.payment, loanAmount: mortgageobj.loanamount)
            }
            if (txtMortgagePayment.text?.isEmpty ?? false || mortgageobj.payment == 0) && txtMortgageInterest.text?.isEmpty != true && txtMortgageLoanAmmount.text?.isEmpty != true && txtMortgageNumberofYears.text?.isEmpty != true {
                mortgageobj.payment = mortgageobj.calculateMortgagePayment(numberOfYears: mortgageobj.numberofyears, interest: mortgageobj.interest, loanAmount: mortgageobj.loanamount)
            }
            if (txtMortgageNumberofYears.text?.isEmpty ?? false || mortgageobj.numberofyears == 0) && txtMortgageInterest.text?.isEmpty != true && txtMortgagePayment.text?.isEmpty != true && txtMortgageLoanAmmount.text?.isEmpty != true {
                mortgageobj.numberofyears = mortgageobj.calculateLoanTermInYears(payment: mortgageobj.payment, interest: mortgageobj.interest, loanAmount: mortgageobj.loanamount)
            }
            
            saveMortgageLastData();
            
            txtMortgageLoanAmmount.text = addThousandSeparators(to: String(mortgageobj.loanamount))
            txtMortgageInterest.text = addThousandSeparators(to: String(mortgageobj.interest))
            txtMortgagePayment.text = addThousandSeparators(to: String(mortgageobj.payment))
            txtMortgageNumberofYears.text = addThousandSeparators(to: String(mortgageobj.numberofyears))
            
        }else{
            mortgage = Mortgage.init(loanamount: 0, interest: 0, payment: 0, numberofyears: 0, insertIntomanagedObjectContext: self.context)
            
            self.calculateValues()
        }
    }

    
    private func saveMortgageLastData(){
        do{
            try self.context?.save()
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func loadMortgageLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mortgage")
        do{
            let mortgagedetails = try self.context?.fetch(request) as! [Mortgage]
            if(mortgagedetails.count>0){
                mortgage = mortgagedetails[0]
                
                txtMortgageLoanAmmount.text = addThousandSeparators(to: String(mortgagedetails[0].loanamount))
                txtMortgageInterest.text = addThousandSeparators(to: String(mortgagedetails[0].interest))
                txtMortgagePayment.text = addThousandSeparators(to: String(mortgagedetails[0].payment))
                txtMortgageNumberofYears.text = addThousandSeparators(to: String(mortgagedetails[0].numberofyears))
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    private func truncateEntity() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Mortgage")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context?.execute(batchDeleteRequest)

            // Save the managed object context to apply the changes to the persistent store
            try self.context?.save()

            print("All records in Mortgage have been deleted.")
        } catch {
            print("Error truncating Mortgage: \(error)")
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
