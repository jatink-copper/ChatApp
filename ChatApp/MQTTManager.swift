//
//  File.swift
//  ChatApp
//
//  Created by Jatin on 20/01/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

//import Foundation
//import MQTTKit
//
//let HOST_ADDRESS = "broker.hivemq.com"
//let SUBSCRIPTION_TOPIC_PREFIX = "ChatApp/chat/"
//
// 
//protocol MessageReceived {
//    func newMessagReceived ( message : Message)
//}
//
//class MQTTManager {
//    var client: MQTTClient?
//    
//
//
//    var delegate : MessageReceived?
//    var wasDisabled = false
//    private var reachability : Reachability!
//
//
//    
////    let coreDataManager = CoreDataManager.sharedInstance
//    
//    class var sharedInstance: MQTTManager {
//        struct Singleton {
//            static let instance = MQTTManager()
//        }
//        return Singleton.instance
//    }
//    
//    //MARK: MQTT Connection
//    
//    /***Connect to Host***/
//    
//    func setUpMqttClient() {
//        var UserId : String?
//        UserId = "1"
//        
//        if let
//            userID = UserId,
//            let uniqueID = UIDevice.current.identifierForVendor {
//            let uniqueID = "\(uniqueID.uuidString)/userID/"+userID
//            self.client = MQTTClient(clientId: uniqueID)
//            client?.port = 1883
//            self.client?.keepAlive = 30 //send requests for every 30secs to keep connection active
//            self.client?.cleanSession = false
//
//            self.setUpMessageHandler()
//            self.connectToHostWithUserID(userID: userID)
////            self.unSubscribeToTopicWithUserID(userID: userID)
//        }
//    }
//    
//    func setUpReachability() {
//        NotificationCenter.default.addObserver(self, selector:#selector(MQTTManager.checkForReachability(notification:)), name:ReachabilityChangedNotification, object: nil)
//        reachability = Reachability()
//        do{try self.reachability.startNotifier()}catch{}
//    }
//    
//    func connectToHostWithUserID(userID: String) {
//        if let client = self.client {
//            client.connect(toHost: HOST_ADDRESS, completionHandler: { (connectionCode) in
//                if connectionCode == ConnectionAccepted {
//                    /***After successfull connection, subscribe user to a topic***/
//                    self.subscribeToTopicWithUserID(userID: userID)
//                } else {
////                    let error = SpornadoNetworking.sharedInstance.createUnknownErrorObjectWithErrorCode()
////                    debugPrint(error)
//                    "Error"
//                }
//            })
//        }
//    }
//    
//    func disconnectToMQQTTHost() {
//        if let client = self.client {
//            client.disconnect(completionHandler: { (disconnectCode) in
//                debugPrint(disconnectCode)
//            })
//        }
//    }
//    
//    //MARK: MQTT Subscription
//    
//    /***Subscribe to a Topic, in order listen to all messages published to this topic***/
//    
//    private func subscribeToTopicWithUserID(userID: String) {
//        if let client = self.client {
//            client.subscribe(SUBSCRIPTION_TOPIC_PREFIX+userID, withQos:AtMostOnce , completionHandler: { (response) in
//                debugPrint("Subscribed successfully")
//                debugPrint(response)
//                /***After successfull Subscription, setup message handler***/
//            })
//    
//        }
//    }
//    
//    //MARK: MQTT Unsubscribe
//    
//    /***Unsubscribe to a Topic***/
//    
//    func unSubscribeToTopicWithUserID(userID: String) {
//        if let client = self.client {
//            client.unsubscribe(SUBSCRIPTION_TOPIC_PREFIX+userID, withCompletionHandler: {
//                debugPrint("Unsubscribed successfully")
//                self.disconnectToMQQTTHost()
//                /****Disconnect after unsubscribing***/
//            })
//        }
//    }
//    
//    //MARK: MQTT Message handler
//    
//    /***Receives Messages published for subsribed topic/s***/
//    
//    private func setUpMessageHandler() {
//        if let client = self.client {
//            
//            client.messageHandler = {(message: MQTTMessage?) in
//                if let messageData = message?.payload {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: messageData, options: JSONSerialization.ReadingOptions.allowFragments)
//                        if let messageDictionary = json as? NSDictionary , let text = messageDictionary ["message_text"] as? String , let senderId = messageDictionary ["message_sender_id"] as? String, let receiverID = messageDictionary ["message_receiver_id"] as? String , let date = messageDictionary ["date"] as? String {
//                            let message = Message(messageSenderID: senderId, messageReceiverID: receiverID, messageText: text, messageDate: DateManager.dateFrom(string: date, withFormat: "MM-dd-yyyy HH:mm:ss") as NSDate)
//                            if let delegate = self.delegate {
//                                delegate.newMessagReceived(message: message)
//                            }
//                            
//                            debugPrint(message)
//                        }
//                        debugPrint(json)
//                    } catch {
////                        debugPrint(error)
//                    }
//                }
//            }
//        }
//    }
//    
//  
//
//    
//    //MARK: MQTT Message publishing
//    
//    /***Sends Messages to a specific topic***/
//    
//    func publishMessageToTopicWithMessage(message: Message, otherUserID userID: String) {
//        if let client = self.client {
//            let encodedData = self.convertStructToNSData(message: message)
//            if let error = encodedData.encodingError {
////                showAlertViewWithMSG("Spornado", message: error.localizedDescription)
//                print(error)
//            } else if let data = encodedData.encodedData {
//                client.publishData(data as Data!, toTopic: SUBSCRIPTION_TOPIC_PREFIX+userID, withQos: AtMostOnce, retain: false, completionHandler: { (responseCode) in
//                    debugPrint(responseCode)
//                })
//            }
//        }
//    }
//    
//    
//    
//    func publishImageToTopic(image: UIImage, otherUserID userID: String) {
//    if let client = self.client {
//        
//    let encodedData = UIImagePNGRepresentation(image)
//    let dictionary = ["image":encodedData!]
//        let dataExample : NSData = NSKeyedArchiver.archivedData(withRootObject: dictionary) as NSData
//
//    client.publishData(dataExample as Data!, toTopic: SUBSCRIPTION_TOPIC_PREFIX+userID, withQos: ExactlyOnce, retain: true, completionHandler: { (responseCode) in
//    debugPrint(responseCode)
//    })
//    }
//    }
//    
//    func convertStructToNSData(message: Message) -> (encodedData: NSData?,encodingError: NSError?) {
//        var encodingError: NSError?
//        var encodedData: NSData?
//        var parameters = [String: AnyObject]()
//        parameters["message_sender_id"] = message.messageSenderID as AnyObject?
//        parameters["message_receiver_id"] = message.messageReceiverID as AnyObject?
////        parameters["message_sender_username"] = message.messageSenderUserName
////        parameters["message_receiver_username"] = message.messageReceiverUserName
////        parameters["message_sender_pic"] = message.messageSenderProfilePicture
////        parameters["message_receiver_pic"] = message.messageReceiverProfilePicture
//        parameters["date"] = DateManager.stringFrom(date: message.messageDate as Date, inFormat: "MM-dd-yyyy HH:mm:ss") as AnyObject?
//        //        parameters["message_type"] = message.messageType.descriptionString
//        parameters["message_text"] = message.messageText as AnyObject? as AnyObject?
// 
//
//        //        parameters["message_sender_user_type"] = message.messageSenderUserType
////        parameters["message_receiver_user_type"] = message.messageReceiverUserType
////        parameters["message_sender_fullname"] = message.messageSenderFullName
////        parameters["message_receiver_fullname"] = message.messageReceiverFullName
//        do {
//            let options = JSONSerialization.WritingOptions()
//            encodedData = try JSONSerialization.data(withJSONObject: parameters, options: options) as NSData?
//        } catch {
//            encodingError = error as NSError
//        }
//        return (encodedData, encodingError)
//    }
//    
//    @objc func checkForReachability(notification:NSNotification)
//    {
//        // Remove the next two lines of code. You cannot instantiate the object
//        // you want to receive notifications from inside of the notification
//        // handler that is meant for the notifications it emits.
//        
//        //var networkReachability = Reachability.reachabilityForInternetConnection()
//        //networkReachability.startNotifier()
//        
//        let networkReachability = notification.object as! Reachability;
//        let remoteHostStatus = networkReachability.currentReachabilityStatus
//        switch remoteHostStatus {
//        case .notReachable:
//            print("Not Reachable")
//            wasDisabled = true
////            if let client = self.client {
////                client.disconnect(completionHandler: { (code) in
////                    print(code)
////                })
////            }
//            
//        case.reachableViaWiFi:
////            client?.reconnect()
////            if wasDisabled {
////               setUpMqttClient()
////                wasDisabled = false
////            
////            }
//        
//        print("Reachable via Wifi")
//
//        default:
////            client?.reconnect()
//
//            print("Reachable via WAN")
//        }
//        
//        
//    }
//}
