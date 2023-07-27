//
//  FAQViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/30/23.
//

import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var viewStackSteps: UIStackView!
    @IBOutlet weak var lblFAQTitle: UILabel!
    var faq: FAQ?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let faqdetail = faq{
            lblFAQTitle.text = faqdetail.title
            var count:Int = 1
            for step in faqdetail.steps {
                let stacksubview = createStackView(String(count),step)
                viewStackSteps.addArrangedSubview(stacksubview)
                count = count + 1
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func createStackView (_ stepnumber: String, _ detail: String) -> UIStackView {
        
        
        let viewstack = UIStackView()
        viewstack.axis = .horizontal
        viewstack.alignment = .fill
        viewstack.distribution = .fill
        let lblTitle = UILabel()
        lblTitle.text = "\(stepnumber). "
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textAlignment = .left
        let lblDetail = UILabel()
        lblDetail.text = detail
        lblDetail.font = UIFont.systemFont(ofSize: 14)
        lblDetail.textAlignment = .left
        lblDetail.lineBreakMode = .byWordWrapping
        lblDetail.numberOfLines = 0
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
