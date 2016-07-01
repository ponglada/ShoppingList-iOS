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


}
