//
//  ChatSentTableViewCell.swift
//  liveApp
//
//  Created by Jatin on 07/12/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

class ChatSentTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        bgView.setNeedsLayout()
        bgView.layoutIfNeeded()
//        bgView.backgroundColor = UIColor.laProfileSelectedTab
        enableRound()
    }
    
    func enableRound () {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.bgView.frame
        rectShape.position = self.bgView.center
        rectShape.path = UIBezierPath(roundedRect: self.bgView
            .bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 5.0, height: 5.0)).cgPath
        
        //Here I'm masking the textView's layer with rectShape layer
        self.bgView.layer.mask = rectShape
        bgView.layer.backgroundColor = themeColor.cgColor

    }
}

