  //
//  MQTTClientManager.swift
//  ChatApp
//
//  Created by Jatin on 10/02/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit
import MQTTClient

let HOST_ADDRESS = "www.spornadopost.info"
let SUBSCRIPTION_TOPIC_PREFIX = "ChatApp/chat/"

protocol MessageReceived {
    func newMessagReceived ( message : Message)
}

class MQTTClientManager: NSObject,MQTTSessionDelegate {
    
    class var sharedInstance: MQTTClientManager {
        struct Singleton {
            static let instance = MQTTClientManager()
        }
        return Singleton.instance
    }
    
    private var reachability : Reachability!
    var delegate : MessageReceived?
    var sessionConnected = false
    var sessionError = false
    var sessionReceived = false
    var sessionSubAcked = false
    var session: MQTTSession?
    var wasDisabled = false
    var UserId : String?

    
    
    func setupClient(success:()->()) {
        

        guard let newSession = MQTTSession() else {
            fatalError("Could not create MQTTSession")
        }
        session = newSession
        UserId = "3"
        if let
            userID = UserId,
            let uniqueID = UIDevice.current.identifierForVendor {
            let unique = "\(uniqueID.uuidString)/userID/"+userID
            session?.clientId = unique
        }
        
        session?.protocolLevel = MQTTProtocolVersion(rawValue: 4)!
        session?.persistence.persistent = true
        session?.cleanSessionFlag = false
        session?.willFlag = true
        session?.willMsg = getJsonForStatus(status: "Offline", UserId: UserId!) as Data!
        session?.willTopic = SUBSCRIPTION_TOPIC_PREFIX+UserId!+"/state"
        session?.willRetainFlag = true
        newSession.delegate = self
        newSession.connect(toHost: HOST_ADDRESS, port: 1883, usingSSL: false)
        while !sessionConnected && !sessionError {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        
        newSession.subscribe(toTopic: SUBSCRIPTION_TOPIC_PREFIX+UserId!, at: .exactlyOnce)
        
        while sessionConnected && !sessionError && !sessionSubAcked {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        newSession.publishData(getJsonForStatus(status: "online", UserId: UserId!) as Data!,
                               onTopic: SUBSCRIPTION_TOPIC_PREFIX+UserId!+"/state",
                               retain: false,
                               qos: .exactlyOnce)
        success()
        
    }
    
    func getJsonForStatus(status : String,UserId:String)->NSData?{
        var data = [String:String]()
        data = ["status":status ,"last_seen":DateManager.stringFrom(date: Date(), inFormat: "MM-dd-yyyy HH:mm:ss"),"userId":UserId]
        var encodedData : NSData?
        do {
            let options = JSONSerialization.WritingOptions()
            encodedData = try JSONSerialization.data(withJSONObject: data, options: options) as NSData?
        } catch {
            print("error")
        }
        return encodedData
    
    }
    
    func setUpReachability() {
        NotificationCenter.default.addObserver(self, selector:#selector(MQTTClientManager.checkForReachability(notification:)), name:ReachabilityChangedNotification, object: nil)
        reachability = Reachability()
        do{try self.reachability.startNotifier()}catch{}
    }
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            sessionConnected = true
        case .connectionClosed:
            sessionConnected = false
        default:
            sessionError = true
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
        sessionReceived = true;
        
        if let messageData = data {
            do {
                let json = try JSONSerialization.jsonObject(with: messageData, options: JSONSerialization.ReadingOptions.allowFragments)
                if topic != SUBSCRIPTION_TOPIC_PREFIX+UserId! {
                    debugPrint(json)
                    if let data = json as? NSDictionary {
                    UserManager.sharedInstance.saveUserDetails(data: data)
                    }
                } else {
                if let messageDictionary = json as? NSDictionary , let text = messageDictionary ["message_text"] as? String , let senderId = messageDictionary ["message_sender_id"] as? String, let receiverID = messageDictionary ["message_receiver_id"] as? String , let date = messageDictionary ["date"] as? String {
                    let message = Message(messageSenderID: senderId, messageReceiverID: receiverID, messageText: text, messageDate: DateManager.dateFrom(string: date, withFormat: "MM-dd-yyyy HH:mm:ss") as NSDate,messageType:.Text)

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessage"), object: message, userInfo: nil)
                    
                    debugPrint(message)
                    }
                }
            } catch {
              debugPrint(error)
            }
            }
        
        }
    
    
    
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        sessionSubAcked = true;
        
    }
    
    func publishMessageToTopicWithMessage(message: Message, otherUserID userID: String) {
            if let session = self.session {
                let encodedData = self.convertStructToNSData(message: message)
                if let error = encodedData.encodingError {
                    print(error)
                } else if let data = encodedData.encodedData {
                    
                    session.publishData(data as Data!, onTopic: SUBSCRIPTION_TOPIC_PREFIX+userID, retain: false, qos: .exactlyOnce, publishHandler: { (error) in
                        print(error ?? 0)
                    })
                }
            }
        }
    
    func unsubscribeTheUser(userID: String) {
        if let session = session {
        session.unsubscribeTopic(SUBSCRIPTION_TOPIC_PREFIX+userID)
        }
    }
    
    func unsubAckReceived(_ session: MQTTSession!, msgID: UInt16) {
        print("unsubscribed")
        session.close()
    }
    
    @objc func checkForReachability(notification:NSNotification)
    {
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
        let remoteHostStatus = networkReachability.currentReachabilityStatus
        switch remoteHostStatus {
        case .notReachable:
            print("Not Reachable")
            wasDisabled = true
            session?.disconnect()
            self.session = nil

            
        case.reachableViaWiFi:
            if wasDisabled {
                wasDisabled = false
                self.setupClient {
                    print("success")
                }
            }
            
            
            print("Reachable via Wifi")
            
        default:
            
            print("Reachable via WAN")
        }
        
        
    }
    
    
    func messageDelivered(_ session: MQTTSession!, msgID: UInt16) {
        print(msgID)
    }
    
    
        func convertStructToNSData(message: Message) -> (encodedData: NSData?,encodingError: NSError?) {
            var encodingError: NSError?
            var encodedData: NSData?
            var parameters = [String: AnyObject]()
            parameters["message_sender_id"] = message.messageSenderID as AnyObject?
            parameters["message_receiver_id"] = message.messageReceiverID as AnyObject?
    //        parameters["message_sender_username"] = message.messageSenderUserName
    //        parameters["message_receiver_username"] = message.messageReceiverUserName
    //        parameters["message_sender_pic"] = message.messageSenderProfilePicture
    //        parameters["message_receiver_pic"] = message.messageReceiverProfilePicture
            parameters["date"] = DateManager.stringFrom(date: message.messageDate as Date, inFormat: "MM-dd-yyyy HH:mm:ss") as AnyObject?
            //        parameters["message_type"] = message.messageType.descriptionString
            parameters["message_text"] = message.messageText as AnyObject? as AnyObject?
            
    
    
            //        parameters["message_sender_user_type"] = message.messageSenderUserType
    //        parameters["message_receiver_user_type"] = message.messageReceiverUserType
    //        parameters["message_sender_fullname"] = message.messageSenderFullName
    //        parameters["message_receiver_fullname"] = message.messageReceiverFullName
            do {
                let options = JSONSerialization.WritingOptions()
                encodedData = try JSONSerialization.data(withJSONObject: parameters, options: options) as NSData?
            } catch {
                encodingError = error as NSError
            }
            return (encodedData, encodingError)
        }
    
    func subscribeUserforStatus(userID:String) {
        if let session = session {
        session.subscribe(toTopic: SUBSCRIPTION_TOPIC_PREFIX+userID+"/state", at: .exactlyOnce, subscribeHandler: { (error, nil) in
            print(error ?? "subscribed")
        })
        }
     
    }
    
    func buffered(_ session: MQTTSession!, flowingIn: UInt, flowingOut: UInt) {
        print(flowingIn)
        print(flowingOut)
    }
    
    
}
