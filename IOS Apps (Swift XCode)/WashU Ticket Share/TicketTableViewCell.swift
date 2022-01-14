//
//  TicketTableViewCell.swift
//  WashU Ticket Share
//
//  Created by lecohen on 11/26/21.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var seller: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
