//
//  ChatCVButtonTableViewCell.swift
//  ChatApp
//
//  Created by Jatin on 10/03/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

class ChatCVButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var cvButton: UIButton!
    
    var buttonData : NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let button = buttonData,let titleText = button["title"] as? String {
            cvButton.setTitle(titleText, for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }

    @IBAction func buttonAction(_ sender: Any) {
        let message = Message(messageSenderID: MQTTClientManager.sharedInstance.UserId!, messageReceiverID: "", messageText: (buttonData["title"]as? String)!, messageDate: Date() as NSDate,messageType:.Text)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessage"), object: message, userInfo: nil)
    }
}
