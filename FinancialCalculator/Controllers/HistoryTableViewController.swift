//
//  HistoryTableViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/27/23.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    var historydetails = [History]()
    
    var context:NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    
    private func saveHistory(){
        
        do{
            try self.context?.save()
        }catch let error as NSError {
            print("Could not sabe \(error), \(error.userInfo)")
        }
    }
    
    private func deleteHistory(_ history:History){
        
        do{
            try self.context?.delete(history)
        }catch let error as NSError {
            print("Could not sabe \(error), \(error.userInfo)")
        }
    }
    
    private func loadHistory() -> [History]?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        var nameSort = NSSortDescriptor(key: "createddate", ascending: false)
        
        request.sortDescriptors = [nameSort]

        
        do{
            let historydetails = try self.context?.fetch(request) as! [History]
            if(historydetails.count>0){
                return historydetails
            }else{
                print("No results found")
            }
        }catch{
            print("Error in fetching items")
        }
        return nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let histories = loadHistory(){
           historydetails = histories
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historydetails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? HistoryTableViewCell
        else{
            fatalError("the dequeuwd cell is not an instance of MealTableViewCeell")
        }
        
        if historydetails[indexPath.row].type == "Savings" {
            cell.imgHistoryIcon.image = UIImage(named: "Loan")
        }else if historydetails[indexPath.row].type == "Mortgage" {
            cell.imgHistoryIcon.image = UIImage(named: "Bank")
        }else if historydetails[indexPath.row].type == "Loans" {
            cell.imgHistoryIcon.image = UIImage(named: "PiggyBank")
        }else{
            cell.imgHistoryIcon.image = UIImage(named: "History")
        }
        cell.lblHistoryTitle.text = historydetails[indexPath.row].title
        cell.lblHistoryPrincipalAmount.text = "Amount: \(String(historydetails[indexPath.row].historyamount))"
        cell.lblHistoryPayment.text = "Payment: \(String(historydetails[indexPath.row].historypayment))"
        cell.lblHistoryInterest.text = "Interest: \(String(historydetails[indexPath.row].historyinterest))"
        cell.lblHistoryCreatedDate.text = historydetails[indexPath.row].createddate?.formatted()

        // Configure the cell...

        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
            
            
        case "viewHistory":
            guard let historydetailviewcontroller = segue.destination as? HistoryDetailViewController
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedHistoryCell = sender as? HistoryTableViewCell
            else{
                fatalError("Unexpected sender \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedHistoryCell)
            else{
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHistory = historydetails[indexPath.row]
            historydetailviewcontroller.history = selectedHistory
            historydetailviewcontroller.context = self.context
            
        default:
            fatalError("Unexpected seague identifier \(segue.identifier)")
        }
    }
    
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historydetails.remove(at: indexPath.row)
            tableView.reloadData()
            saveHistory()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
     
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

}
