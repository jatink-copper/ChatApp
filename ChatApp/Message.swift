//
//  Message.swift
//  ChatApp
//
//  Created by Jatin on 23/01/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

enum MessageType:Int {
    case Text,Image,Bot
}

struct Message {
    
    var messageSenderID: String
    var messageReceiverID: String
//    var messageSenderUserName: String
//    var messageReceiverUserName: String
//    var messageSenderFullName: String
//    var messageReceiverFullName: String
//    var messageSenderProfilePicture: String?
    var messageReceiverProfilePicture: String?
//    var messageSenderUserType: String
//    var messageReceiverUserType: String
    var messageText: String
    var messageType: MessageType?
    var messageDate: NSDate
    var messageImage: UIImage?

  
//    var messageID: String
    
    init(messageSenderID:String,messageReceiverID:String,messageText:String,messageDate:NSDate,messageType:MessageType,messageImage:UIImage? = nil) {
        self.messageDate = messageDate
        self.messageReceiverID  = messageReceiverID
        self.messageText = messageText
        self.messageSenderID = messageSenderID
        self.messageType = messageType
        self.messageImage = messageImage

    }
}
