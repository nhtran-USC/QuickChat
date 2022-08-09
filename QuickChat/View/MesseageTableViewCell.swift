//
//  MesseageTableViewCell.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/14/22.
//

import UIKit

class MesseageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabel.layer.masksToBounds = true
        senderLabel.layer.masksToBounds = true
        
        messageLabel.layer.cornerRadius = messageLabel.frame.height / 2
        senderLabel.layer.cornerRadius = senderLabel.frame.height / 2
        
        senderLabel.text = "Me"
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//
//    }
        
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
}
