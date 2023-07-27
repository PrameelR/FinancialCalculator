//
//  TabBarViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    var identifier: String?
    
    
    var barButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Save")
    @IBOutlet weak var tabBarMenu: UITabBar!
    
    var context:NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.delegate = self
        
        if let ident = identifier{
            switch ident {
            case "Savings":
                self.selectedIndex = 2
                self.navigationItem.title = "Savings"
            case "Mortgage":
                self.selectedIndex = 1
                self.navigationItem.title = "Mortgage"
            case "Loans":
                self.selectedIndex = 0
                self.navigationItem.title = "Compounds loans and savings"
            default:
                print("Invalid option \(ident)")
            }
        }
        barButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func saveButtonTapped() {
        let alertController = UIAlertController(title: self.navigationItem.title, message: "Do you wish to save the \(self.navigationItem.title!.lowercased()) calculation?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            
            switch self.selectedIndex {
            case 2:
                self.loadSavingsLastData()
            case 1:
                self.loadMortgageLastData()
            case 0:
                self.loadLoansLastData()
            default:
                print("Invalid option \(self.selectedIndex)")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button tapped.")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func saveLastData(){
        do{
            try self.context?.save()
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func loadMortgageLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mortgage")
        do{
            let details = try self.context?.fetch(request) as! [Mortgage]
            if(details.count>0){
                
                let mortgagehistory = MortgageHistory.init(insertIntomanagedObjectContext: self.context)
                
                mortgagehistory.id = UUID()
                mortgagehistory.historyamount = details[0].loanamount
                mortgagehistory.historyinterest = details[0].interest
                mortgagehistory.historypayment = details[0].payment
                mortgagehistory.title = self.navigationItem.title
                mortgagehistory.type = "Mortgage"
                mortgagehistory.createddate = Date()
                
                mortgagehistory.mortgageid = UUID()
                mortgagehistory.mortgageloanamount = details[0].loanamount
                mortgagehistory.mortageinterest = details[0].interest
                mortgagehistory.mortgagepayment = details[0].payment
                mortgagehistory.mortgagenumberofyears = details[0].numberofyears
                
                saveLastData()
                
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    
    private func loadSavingsLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Savings")
        do{
            let details = try self.context?.fetch(request) as! [Savings]
            if(details.count>0){
                
                let savingshistory = SavingsHistory.init(insertIntomanagedObjectContext: self.context)
                
                savingshistory.id = UUID()
                savingshistory.historyamount = details[0].principalamount
                savingshistory.historyinterest = details[0].interest
                savingshistory.historypayment = details[0].payments
                savingshistory.title = self.navigationItem.title
                savingshistory.type = "Savings"
                savingshistory.createddate = Date()
                
                savingshistory.savingsid = UUID()
                savingshistory.savingsprincipalamount = details[0].principalamount
                savingshistory.savingsinterest = details[0].interest
                savingshistory.savingspayment = details[0].payments
                savingshistory.savingsfuturevalue = details[0].futurevalue
                savingshistory.savingscompoundperyear = details[0].compoundperyear
                savingshistory.savingspaymentsperyear = details[0].paymentsperyear
                savingshistory.savingstotalnumberofpayments = details[0].totalnumberofpayments
                
                saveLastData()
                
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    private func loadLoansLastData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Loan")
        do{
            let details = try self.context?.fetch(request) as! [Loan]
            if(details.count>0){
                
                let loanhistory = LoanHistory.init(insertIntomanagedObjectContext: self.context)
                
                loanhistory.id = UUID()
                loanhistory.historyamount = details[0].presentvalue
                loanhistory.historyinterest = details[0].interest
                loanhistory.historypayment = details[0].payment
                loanhistory.title = self.navigationItem.title
                loanhistory.type = "Loans"
                loanhistory.createddate = Date()
                
                loanhistory.loanid = UUID()
                loanhistory.loanpresentvalue = details[0].presentvalue
                loanhistory.loaninterest = details[0].interest
                loanhistory.loanpayment = details[0].payment
                loanhistory.loanfuturevalue = details[0].futurevalue
                loanhistory.loancompoundsperyear = details[0].compoundperyear
                loanhistory.loannumberofpayments = details[0].numberofpayments
                loanhistory.loanend = details[0].end
                
                
                saveLastData()
                
                
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        // Handle back button tap if needed
        navigationController?.popViewController(animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("seleceted item")
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        if(selectedIndex == 0){
            self.title = "Compounds loans and savings"
            self.navigationItem.rightBarButtonItem = barButtonItem
        }else if(selectedIndex == 1){
            self.title = "Mortgage"
            self.navigationItem.rightBarButtonItem = barButtonItem
        }else if(selectedIndex == 2){
            self.title = "Savings"
            self.navigationItem.rightBarButtonItem = barButtonItem
        }else if(selectedIndex == 3){
            self.title = "History"
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            
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
