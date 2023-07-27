//
//  HistoryTableViewCell.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/29/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblHistoryTitle: UILabel!
    
    @IBOutlet weak var imgHistoryIcon: UIImageView!
    @IBOutlet weak var lblHistoryCreatedDate: UILabel!
    @IBOutlet weak var lblHistoryPayment: UILabel!
    @IBOutlet weak var lblHistoryInterest: UILabel!
    @IBOutlet weak var lblHistoryPrincipalAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
