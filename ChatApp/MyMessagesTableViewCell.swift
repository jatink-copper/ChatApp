//
//  MyMessagesTableViewCell.swift
//  liveApp
//
//  Created by Jatin on 06/12/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

class MyMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.addBorder(withColor: themeColor, andBorderWidth: 2.0)
        bgView.enableRoudedCorner()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        userImageView.layoutIfNeeded()
        userImageView.makeItCircle()
    }

}
