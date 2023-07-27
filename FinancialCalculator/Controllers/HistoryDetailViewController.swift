//
//  HistoryDetailViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/30/23.
//

import UIKit
import CoreData

class HistoryDetailViewController: UIViewController {

    var history: History?
    
    
    @IBOutlet weak var viewStackBody: UIStackView!
    @IBOutlet weak var lblHistoryTitle: UILabel!
    
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let histdetail = history {
            lblHistoryTitle.text = histdetail.title
            if(histdetail.type == "Mortgage"){
                loadMortgageDetails()
            }else if(histdetail.type == "Loans"){
                loadLoansDetails()
            }else if(histdetail.type == "Savings"){
                loadSavingsDetails()
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    private func loadMortgageDetails() {
        
        if let selectuuid = history?.id {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MortgageHistory")
            
            request.predicate = NSPredicate(format: "id == %@", selectuuid as CVarArg)
            
            do{
                let mortgagdetails = try self.context?.fetch(request) as! [MortgageHistory]
                
                if(mortgagdetails.count>0){
                    
                    let viewAmountStack = createStackView("Loan amount",addThousandSeparators(to: String(mortgagdetails[0].mortgageloanamount)) ?? "-")
                    let viewInterestStack = createStackView("Interest",String(mortgagdetails[0].mortageinterest))
                    let viewPaymentStack = createStackView("Payment",addThousandSeparators(to: String(mortgagdetails[0].mortgagepayment)) ?? "-")
                    let viewYearsStack = createStackView("Number of years",String(mortgagdetails[0].mortgagenumberofyears))
                    
                    
                    viewStackBody.addArrangedSubview(viewAmountStack)
                    viewStackBody.addArrangedSubview(viewInterestStack)
                    viewStackBody.addArrangedSubview(viewPaymentStack)
                    viewStackBody.addArrangedSubview(viewYearsStack)
                    
                    
                }else{
                    print("No results found")
                }
            }catch{
                print("Error in fetching items")
            }
        }else{
            print("UUID not available")
        }
    }
    
    private func loadSavingsDetails() {
        if let selectuuid = history?.id {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavingsHistory")
            
            request.predicate = NSPredicate(format: "id == %@", selectuuid as CVarArg)
            
            do{
                let savingsdetails = try self.context?.fetch(request) as! [SavingsHistory]
                
                if(savingsdetails.count>0){
                    
                    let viewPrincipalAmountStack = createStackView("Principal amount",addThousandSeparators(to: String(savingsdetails[0].savingsprincipalamount)) ?? "-")
                    let viewInterestStack = createStackView("Interest",String(savingsdetails[0].savingsinterest))
                    let viewPaymentStack = createStackView("Payment",addThousandSeparators(to: String(savingsdetails[0].savingspayment)) ?? "-")
                    let viewFutureValueStack = createStackView("Future value",addThousandSeparators(to: String(savingsdetails[0].savingsfuturevalue)) ?? "-")
                    let viewCompoundsPerYearStack = createStackView("Compounds per year",String(savingsdetails[0].savingscompoundperyear))
                    let viewPaymentsPerYearStack = createStackView("Payments per year",String(savingsdetails[0].savingspaymentsperyear))
                    let viewNumberOfPaymentsStack = createStackView("Total no. of payments",String(savingsdetails[0].savingstotalnumberofpayments))
                    
                    
                    viewStackBody.addArrangedSubview(viewPrincipalAmountStack)
                    viewStackBody.addArrangedSubview(viewInterestStack)
                    viewStackBody.addArrangedSubview(viewPaymentStack)
                    viewStackBody.addArrangedSubview(viewFutureValueStack)
                    viewStackBody.addArrangedSubview(viewCompoundsPerYearStack)
                    viewStackBody.addArrangedSubview(viewPaymentsPerYearStack)
                    viewStackBody.addArrangedSubview(viewNumberOfPaymentsStack)
                    
                    
                }else{
                    print("No results found")
                }
            }catch{
                print("Error in fetching items")
            }
        }else{
            print("UUID not available")
        }
    }
    
    private func loadLoansDetails() {
        
        if let selectuuid = history?.id {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LoanHistory")
            
            request.predicate = NSPredicate(format: "id == %@", selectuuid as CVarArg)
            
            do{
                let loandetails = try self.context?.fetch(request) as! [LoanHistory]
                
                if(loandetails.count>0){
                    
                    let viewPresentValueStack = createStackView("Present value",addThousandSeparators(to: String(loandetails[0].loanpresentvalue)) ?? "-")
                    let viewInterestStack = createStackView("Interest",String(loandetails[0].loaninterest))
                    let viewPaymentStack = createStackView("Payment",addThousandSeparators(to: String(loandetails[0].loanpayment)) ?? "-")
                    let viewFutureValueStack = createStackView("Future value",addThousandSeparators(to: String(loandetails[0].loanfuturevalue)) ?? "-")
                    let viewCompoundsPerYearStack = createStackView("Compounds per year",String(loandetails[0].loancompoundsperyear))
                    let viewPaymentsPerYearStack = createStackView("Payments per year",String(loandetails[0].loannumberofpayments))
                    var isend: String = "No"
                    if(loandetails[0].loanend){
                        isend = "Yes"
                    }
                    let viewEndStackView = createStackView("End",isend)
                    
                    
                    viewStackBody.addArrangedSubview(viewPresentValueStack)
                    viewStackBody.addArrangedSubview(viewInterestStack)
                    viewStackBody.addArrangedSubview(viewPaymentStack)
                    viewStackBody.addArrangedSubview(viewFutureValueStack)
                    viewStackBody.addArrangedSubview(viewCompoundsPerYearStack)
                    viewStackBody.addArrangedSubview(viewPaymentsPerYearStack)
                    viewStackBody.addArrangedSubview(viewEndStackView)
                    
                    
                }else{
                    print("No results found")
                }
            }catch{
                print("Error in fetching items")
            }
        }else{
            print("UUID not available")
        }
    }
    
    func createStackView (_ title: String, _ detail: String) -> UIStackView {
        
        
        let viewstack = UIStackView()
        viewstack.axis = .horizontal
        viewstack.alignment = .fill
        viewstack.distribution = .fillProportionally
        let lblTitle = UILabel()
        lblTitle.text = "\(title): "
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textAlignment = .left
        let lblDetail = UILabel()
        lblDetail.text = detail
        lblDetail.font = UIFont.systemFont(ofSize: 14)
        lblDetail.textAlignment = .right
        viewstack.addArrangedSubview(lblTitle)
        viewstack.addArrangedSubview(lblDetail)
        
        return viewstack
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
