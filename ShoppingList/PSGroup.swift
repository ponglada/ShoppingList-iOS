//
//  PSGroup.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/21/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import Foundation
import CoreData

let PSGroupEntityName = "Group"

class PSGroup: NSManagedObject {
    
    @NSManaged func addMembersObject(member: PSUser)
    @NSManaged func removeMembersObject(member: PSUser)
    
    static var pGroup: PSGroup?
    
    static func newGroup(name: String, owner: PSUser, save: Bool) -> PSGroup {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let group = NSEntityDescription.insertNewObjectForEntityForName(PSGroupEntityName, inManagedObjectContext: moc) as! PSGroup
        group.owner = owner
        group.addMembersObject(owner)
        group.name = name
        
        if save {
            do {
                try moc.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            
        }
        
        return group
    }

    static func personalGroup() -> PSGroup? {
        if let pg = self.pGroup {
            return pg
        }
        
        return PSUser.currentUser().personalGroup()
    }
    
    static func allGroups() -> [PSGroup] {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let request = NSFetchRequest(entityName: PSGroupEntityName)
        
        var allGroups: [PSGroup]
        do {
            try allGroups = moc.executeFetchRequest(request) as! [PSGroup]
        } catch {
            fatalError("Failed to fetch all groups: \(error)")
        }
        return allGroups
    }

}
