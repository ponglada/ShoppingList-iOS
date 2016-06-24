//
//  PSUser.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/21/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import Foundation
import CoreData

let PSUserEntityName = "User"

class PSUser: NSManagedObject {

    static var cUser: PSUser?
    
    static func newUser(name: String, email: String, save: Bool) -> PSUser {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let user = NSEntityDescription.insertNewObjectForEntityForName(PSUserEntityName, inManagedObjectContext: moc) as! PSUser
        user.name = name
        user.email = email
        
        if save {
            do {
               try moc.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            
        }
        
        return user
    }
    
    static func currentUser() -> PSUser {
        if let cu = cUser {
            return cu
        }
        
        let email = NSUserDefaults.standardUserDefaults().objectForKey(PSUserDefaultsCurrentUserKey) as! String
        let moc = PSDataController.sharedInstance.managedObjectContext
        let request = NSFetchRequest(entityName: PSUserEntityName)
        request.predicate = NSPredicate(format: "email = %@", email)
        
        var users: [PSUser]
        do {
            try users = moc.executeFetchRequest(request) as! [PSUser]
        } catch {
            fatalError("Failed to fetch current user: \(error)")
        }
        
        return users[0]
    }
    
    func personalGroup() -> PSGroup? {
        let predicate = NSPredicate(format: "isPersonal = %@", true)
        let pGroups = self.groups?.filteredSetUsingPredicate(predicate)
        if pGroups?.count > 0 {
            return pGroups?.first as? PSGroup
        }
        return nil
    }

}
