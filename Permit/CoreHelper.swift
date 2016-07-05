//
//  CoreHelper.swift
//  Permit
//
//  Created by Miroslav on 6/28/16.
//  Copyright © 2016 Miroslav. All rights reserved.
//

import Foundation
import CoreData

public class CoreHelper: NSObject {
    
    static let sharedInstance = CoreHelper()
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.permit.Permit" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Permit", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func getAllPermits() -> [Permit] {
        let context = self.managedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Permit", inManagedObjectContext: context)
        var permitResults: [Permit] = []
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for(var i = 0; i < result.count; i++) {
                let managedObject = result[i]
                let p = Permit(object: managedObject)
                permitResults.append(p)
            }
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return permitResults
    }

    func addPermit(permit: Permit, completionHander: (Bool?, AnyObject?) -> ()) {
        let context = self.managedObjectContext
        let object: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Permit", inManagedObjectContext: context)

        object.setValue(permit.builder, forKey: "builder")
        object.setValue(permit.customer, forKey: "customer")
        object.setValue(permit.site_address, forKey: "site_address")
        object.setValue(permit.contact_phone_number, forKey: "contact_phone_number")
        object.setValue(permit.contact_cell_phone_number, forKey: "contact_cell_phone_number")
        object.setValue(permit.permit_number, forKey: "permit_number")
        object.setValue(permit.permit_open_date, forKey: "permit_open_date")
        object.setValue(permit.permit_close_date, forKey: "permit_close_date")
        object.setValue(permit.permit_jurisdiction, forKey: "permit_jurisdiction")
        var lock_status = 0
        if permit.lock_status == .CLOSE {
            lock_status = 1
        }
        object.setValue(NSNumber(integer: lock_status), forKey: "lock_status")
        
        var permit_status = 0
        if permit.permit_status == .PASSED {
            permit_status = 1
        } else if permit.permit_status == .FAILED {
            permit_status = 2
        }
        
        object.setValue(NSNumber(integer: permit_status), forKey: "permit_status")
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                completionHander(true, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completionHander(false, nserror)
            }
        }
    }
    
    func updatePermit(permit: Permit, completionHander: (Bool?, AnyObject?) -> ()) {
        let context = self.managedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Permit", inManagedObjectContext: context)
        fetchRequest.predicate = NSPredicate(format: "permit_number == %@", permit.permit_number!)
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let object: NSManagedObject;
            if result.count > 0 {

                object = result[0]
                object.setValue(permit.builder, forKey: "builder")
                object.setValue(permit.customer, forKey: "customer")
                object.setValue(permit.site_address, forKey: "site_address")
                object.setValue(permit.contact_phone_number, forKey: "contact_phone_number")
                object.setValue(permit.contact_cell_phone_number, forKey: "contact_cell_phone_number")
                object.setValue(permit.permit_number, forKey: "permit_number")
                object.setValue(permit.permit_open_date, forKey: "permit_open_date")
                object.setValue(permit.permit_close_date, forKey: "permit_close_date")
                object.setValue(permit.permit_jurisdiction, forKey: "permit_jurisdiction")
                
                var lock_status = 0
                if permit.lock_status == .CLOSE {
                    lock_status = 1
                }
                object.setValue(NSNumber(integer: lock_status), forKey: "lock_status")
                
                var permit_status = 0
                if permit.permit_status == .PASSED {
                    permit_status = 1
                } else if permit.permit_status == .FAILED {
                    permit_status = 2
                }
                
                object.setValue(NSNumber(integer: permit_status), forKey: "permit_status")
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                        completionHander(true, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completionHander(false, nserror)
                    }
                }
            }
            else {
                completionHander(false, nil)
            }
            
        } catch let error as NSError {
            // failure
            completionHander(false, error)
        }
    }
    
    func deletePermit(permit: Permit, completionHander: (Bool?, AnyObject?) -> ()) {
        let context = self.managedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Permit", inManagedObjectContext: context)
        fetchRequest.predicate = NSPredicate(format: "permit_number == %@", permit.permit_number!)
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let object: NSManagedObject;
            if result.count > 0 {
                
                object = result[0]
                managedObjectContext.deleteObject(object)
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                        completionHander(true, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completionHander(false, nserror)
                    }
                }
            }
            else {
                completionHander(false, nil)
            }
            
        } catch let error as NSError {
            // failure
            completionHander(false, error)
        }

    }
}
