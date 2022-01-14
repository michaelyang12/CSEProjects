//
//  MessagesTableViewCell.swift
//  WashU Ticket Share
//
//  Created by Jade Wang on 12/5/21.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var recentMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
