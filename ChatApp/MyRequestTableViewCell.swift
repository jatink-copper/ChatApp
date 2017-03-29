//
//  MyRequestTableViewCell.swift
//  liveApp
//
//  Created by Jatin on 06/12/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

class MyRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.addBorder(withColor: themeColor, andBorderWidth: 2.0)
        acceptButton.enableRoudedCorner()
        acceptButton.backgroundColor = themeColor
        rejectButton.addBorder(withColor:   themeColor, andBorderWidth: 1.0)
        acceptButton.enableRoudedCorner()
        rejectButton.enableRoudedCorner()
        bgView.enableRoudedCorner()
    }

    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override func layoutSubviews() {
        userImageView.layoutIfNeeded()
        userImageView.makeItCircle()
    }

}
