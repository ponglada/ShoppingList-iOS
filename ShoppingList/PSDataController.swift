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
let PSUserDefaultsCurrentSheetKey = "PS Current Sheet Key"


class PSDataController: NSObject {
    
    static let sharedInstance = PSDataController()
    var currentUser: PSUser?
    var currentSheet: PSSheet?
    
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
                } else {
                    self.loadCurrentState()
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
        let newSheet = PSSheet.newSheet("My Shopping List", owner: newUser, save: false)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failed to save context: \(error)")
        }
        
        self.currentUser = newUser
        self.currentSheet = newSheet
        self.saveCurrentState()
    }
    
    func loadCurrentState() {
        let userID = NSUserDefaults.standardUserDefaults().URLForKey(PSUserDefaultsCurrentUserKey)
        let sheetID = NSUserDefaults.standardUserDefaults().URLForKey(PSUserDefaultsCurrentSheetKey)
        print("Retrieve current user: \(userID)")
        let moc = self.managedObjectContext
        
        if let uid = userID, let sid = sheetID {
            let uObjectID = moc.persistentStoreCoordinator!.managedObjectIDForURIRepresentation(uid)
            let sObjectID = moc.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(sid)
            
            if let uObId = uObjectID, let sObId = sObjectID {
                self.currentUser = moc.objectWithID(uObId) as? PSUser
                self.currentSheet = moc.objectWithID(sObId) as? PSSheet
            }
        }
    }
    
    func saveCurrentState() {
        let userID = self.currentUser?.objectID.URIRepresentation()
        let sheetID = self.currentSheet?.objectID.URIRepresentation()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: PSUserDefaultsNotFirstTimeKey)
        NSUserDefaults.standardUserDefaults().setURL(userID, forKey: PSUserDefaultsCurrentUserKey)
        NSUserDefaults.standardUserDefaults().setURL(sheetID, forKey: PSUserDefaultsCurrentSheetKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
