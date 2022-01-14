//
//  PastTransactionsTableViewCell.swift
//  WashU Ticket Share
//
//  Created by Jade Wang on 12/5/21.
//

import UIKit

class PastTransactionsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
