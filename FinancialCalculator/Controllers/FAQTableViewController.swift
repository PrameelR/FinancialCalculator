//
//  FAQTableViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//
import UIKit

class FAQTableViewController: UITableViewController {

    
    var faqs = [FAQ]()
    @IBOutlet weak var tabMenuItemFAQ: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let questions = loadFAQs(){
            faqs = questions
        }
        
    }
    
    func loadFAQs() -> [FAQ]?{
        let plistURL = Bundle.main.url(forResource: "AppInfo", withExtension: "plist")!
        do {
            let plistData = try Data(contentsOf: plistURL)
            let decoder = PropertyListDecoder()
            let rootDict = try PropertyListSerialization.propertyList(from: plistData, format: nil) as! [String: Any]
            
            var questions: [FAQ] = []
            if let faqArray = rootDict["FAQs"] as? [[String: Any]] {
                for faqDict in faqArray {
                    if let title = faqDict["Title"] as? String, let steps = faqDict["Steps"] as? [String] {
                        let faq = FAQ(title: title, steps: steps)
                        questions.append(faq)
                    }
                }
                
                return questions
                
            } else {
                print("FAQs array not found in plist.")
            }
            
        } catch {
            print("Error loading plist data: \(error)")
        }
        
        return nil
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return faqs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? FAQTableViewCell
        else{
            fatalError("the dequeuwd cell is not an instance of MealTableViewCeell")
        }
        
        cell.lblQuestionTitle.text = faqs[indexPath.row].title
        // Configure the cell...

        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       switch(segue.identifier ?? ""){
            
            
        case "viewFAQ":
            guard let faqviewcontroller = segue.destination as? FAQViewController
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedFAQCell = sender as? FAQTableViewCell
            else{
                fatalError("Unexpected sender \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedFAQCell)
            else{
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedfaq = faqs[indexPath.row]
            faqviewcontroller.faq = selectedfaq
           
            
        default:
            fatalError("Unexpected seague identifier \(segue.identifier)")
        }
    }
    
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
        } else if editingStyle == .insert {
            print("Edit")
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
     
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

}
