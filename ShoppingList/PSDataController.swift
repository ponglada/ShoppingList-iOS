//
//  PSDataController.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/21/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit
import CoreData

let PSFinishedLoadingFromPersistentStore = "Finish loading from persistent Store"
let PSUserDefaultsNotFirstTimeKey = "PS Not First Time Key"
let PSUserDefaultsCurrentUserKey = "PS Current User Key"


class PSDataController: NSObject {
    
    static let sharedInstance = PSDataController()
    
    var managedObjectContext: NSManagedObjectContext!
    var loadedFromPersistentStore: Bool = false
    
    
    func setupCoreData() {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("MainModel", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        
        // Load data from persistent store
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.URLByAppendingPathComponent("MainModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            
            dispatch_sync(dispatch_get_main_queue(), {
                // Init first time user here
                let userDefault = NSUserDefaults.standardUserDefaults()
                if !userDefault.boolForKey(PSUserDefaultsNotFirstTimeKey) {
                    print("Prepare initializing first time user")
                    self.initializeFirstTimeUser()
                }
                
                
                self.loadedFromPersistentStore = true
                NSNotificationCenter.defaultCenter().postNotificationName(PSFinishedLoadingFromPersistentStore, object: self)
            })
            
            
            // Sync with server
            // If there are duplicate personal group, merge here
            
            
        })
    }
    
    
    func initializeFirstTimeUser() {
        let newUser = PSUser.newUser("Sample", email: "sample@email.com", save: false)
        let newPersonalGroup = PSGroup.newGroup("Personal", owner: newUser, save: false)
        newPersonalGroup.isPersonal = true
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failed to save context: \(error)")
        }
        
        PSUser.cUser = newUser
        PSGroup.pGroup = newPersonalGroup
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: PSUserDefaultsNotFirstTimeKey)
        NSUserDefaults.standardUserDefaults().setObject(newUser.email, forKey: PSUserDefaultsCurrentUserKey)
    }
}
