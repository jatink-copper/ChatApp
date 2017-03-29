//
//  UserManager.swift
//  ChatApp
//
//  Created by Jatin on 15/02/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

protocol updateStatusDelegate {
    func updateStatus(status:Bool)
}

class UserManager: NSObject {
    
    class var sharedInstance : UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
    
    var delegate : updateStatusDelegate?
    var userID : String?
    
    
    func saveUserDetails(data : NSDictionary) {
        let context = CoreDataManager.sharedInstance.getNewChildContext()
        
        if let userId = data["userId"] as? String {
            var status = false
            if let user = getUser(withID: userId) {
                if let status = data["status"] as? String {
                    if status == "online" {
                        user.status = true
                    } else {
                        user.status = false
                    }
                }
                user.lastSeen = data["last_seen"] as? String
                user.userId = userId
                status = user.status
                
            } else {
                let user = CoreDataManager.sharedInstance.createEntityForClass(named: "UserDetails", inContext: context) as! UserDetails
                user.userId = userId
                if let status = data["status"] as? String {
                    if status == "online" {
                        user.status = true
                    } else {
                        user.status = false
                    }
                }
                user.lastSeen = data["last_seen"] as? String
                status = user.status
                

            }
            
            if let id = userID, id == userId,let delegate = delegate {
            delegate.updateStatus(status: status)
            
            }
            
            
        }
        
        context.saveContext()
    
        
    }
    
    func getUser(withID userID: String)->UserDetails? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        
        let dataMatchingPredicate =  NSPredicate(format: "userId == %@", userID)
        fetchRequest.predicate = dataMatchingPredicate
        let user = CoreDataManager.sharedInstance.executeFetchRequest(fetchRequest: fetchRequest) as! [UserDetails]
        return user.first
    }
    
    func getStatus(userId: String) -> Bool {
        if let user = getUser(withID: userId) {
            
            return user.status
    
    }
        return false
    }


}
