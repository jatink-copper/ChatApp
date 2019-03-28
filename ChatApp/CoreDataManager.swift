//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Jatin on 30/01/17.
//  Copyright © 2017 Jatin. All rights reserved.
//
import UIKit
import CoreData
import Foundation

public enum SaveResult {
    case Success
}

let CoreDataManagerSharedInstance = CoreDataManager()

class CoreDataManager: NSObject {
    
    class var sharedInstance: CoreDataManager {
        
        return CoreDataManagerSharedInstance
    }
    
    // MARK: Properties
    lazy private var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "ChatApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ChatApp.sqlite")
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                                                                                   NSInferMappingModelAutomaticallyOption: true])
        }
        catch {
            print("Unresolved error \(error)")
            abort()
        }
        
        return coordinator
    }()
    
    /*
     Primary persisting background managed object context. This is the top level context that possess an
     NSPersistentStoreCoordinator and saves changes to disk on a background queue.
     
     Fetching, Inserting, Deleting or Updating managed objects should occur on a child of this context rather than directly.
     */
    lazy private var privateQueueContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        managedObjectContext.name = "Primary Private Queue Context (Persisting Context)"
        return managedObjectContext
    }()
    
    /**
     The main queue context for any work that will be performed on the main queue.
     Its parent context is the primary private queue context that persist the data to disk.
     Making a save() call on this context will automatically trigger a save on its parent via NSNotification.
     */
    lazy private var mainQueueContext: NSManagedObjectContext? = {
        
        var managedObjectContext: NSManagedObjectContext!
        let setup: () -> Void = {
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
            managedObjectContext.parent = self.privateQueueContext
            managedObjectContext.name = "Main Queue Context (UI Context)"
        }
        
        // Always create the main-queue ManagedObjectContext on the main queue.
        if !Thread.isMainThread {
            
            DispatchQueue.main.sync() {
                setup()
            }
        } else {
            
            setup()
        }
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(stackMemberContextDidSaveNotification(notification:)),
                                                         name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                         object: managedObjectContext)
        return managedObjectContext
        
    }()
    
    // MARK: Methods
    // Saving Notification
     func stackMemberContextDidSaveNotification(notification: NSNotification) {
        
        guard let notificationMOC = notification.object as? NSManagedObjectContext else {
            assertionFailure("Notification posted from an object other than an NSManagedObjectContext")
            return
        }
        
        guard let parentContext = notificationMOC.parent else {
            return
        }
        
        do {
            
            try parentContext.save()
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    // Creation Methods
    func getNewChildContext() -> NSManagedObjectContext{
        
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        moc.name = "Background Worker Context"
        moc.parent = mainQueueContext
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(stackMemberContextDidSaveNotification(notification:)),
                                                         name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                         object: moc)
        return moc
    }
    
    func getManagedObjectModel() -> NSManagedObjectModel{
        return managedObjectModel
    }
    
    func createEntityForClass(named: String, inContext: NSManagedObjectContext) -> NSManagedObject{
        
        var newManagedObject : NSManagedObject!
        inContext.performAndWait { () -> Void in
            
            newManagedObject = NSEntityDescription.insertNewObject(forEntityName: named, into: inContext)
        }
        return newManagedObject
    }
    
    func getMainContext() -> NSManagedObjectContext {
        return mainQueueContext!
    }
    
    // Deletion Methods
    func resetDataBase() {
        
        mainQueueContext?.performAndWait({ () -> Void in
            
            let entities = self.managedObjectModel.entities
            for entityDescription in entities {
                    self.deleteAllObjectsWithEntityName(entityName: entityDescription.name!, context: self.mainQueueContext!)
                    
            }
        })
        
        do {
            
            try mainQueueContext!.save()
        } catch let error as NSError {
            
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllObjectsWithEntityName(entityName: String, context: NSManagedObjectContext){
        
        mainQueueContext?.performAndWait({ () -> Void in
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            let items = try? self.mainQueueContext!.fetch(fetchRequest)
            for item in items! {
                self.mainQueueContext?.delete(item as! NSManagedObject)
            }
        })
    }
    
    // Fetch Request
    func executeFetchRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject] {
        
        var result = [NSManagedObject]()
        
        do {
            
            let results = try mainQueueContext!.fetch(fetchRequest)
            result = results as! [NSManagedObject]
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
        return result
    }
    
}
extension NSManagedObjectContext {
    /**
     Convenience method to synchronously save the managed object context if changes are present.
     */
    public func saveContextAndWait() {
        //var saveError: ErrorType?
        self.performAndWait { [unowned self] in
            let _ = try? self.sharedSaveFlow()
            
        }
        
        
    }
    
    /**
     Convenience method to asynchronously save the managed object context if changes are present.
     
     :param: completion Completion closure with a SaveResult to be executed upon the completion of the save operation.
     */
    public func saveContext(completion: ((SaveResult) -> Void)? = nil) {
        do {
            try sharedSaveFlow()
            completion?(.Success)
        } catch let saveError {
            print(saveError)
        }
    }
    
    private func sharedSaveFlow() throws {
        if hasChanges {
            do {
                try save()
            } catch let error {
                throw error
            }
        }
    }
}

