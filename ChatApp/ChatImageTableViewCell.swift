//
//  ChatImageTableViewCell.swift
//  ChatApp
//
//  Created by Jatin on 09/03/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
