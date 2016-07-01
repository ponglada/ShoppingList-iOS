//
//  PSSheet.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/30/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import Foundation
import CoreData


let PSSheetEntityName = "Sheet"

class PSSheet: NSManagedObject {

    @NSManaged func addMembersObject(member: PSUser)
    @NSManaged func removeMembersObject(member: PSUser)
    
    static func newSheet(name: String, owner: PSUser, save: Bool) -> PSSheet {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let sheet = NSEntityDescription.insertNewObjectForEntityForName(PSSheetEntityName, inManagedObjectContext: moc) as! PSSheet
        sheet.owner = owner
        sheet.addMembersObject(owner)
        sheet.name = name
        
        if save {
            do {
                try moc.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            
        }
        
        return sheet
    }
    
    static func allSheets() -> [PSSheet] {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let request = NSFetchRequest(entityName: PSSheetEntityName)
        
        var allSheets: [PSSheet]
        do {
            try allSheets = moc.executeFetchRequest(request) as! [PSSheet]
        } catch {
            fatalError("Failed to fetch all Sheets: \(error)")
        }
        return allSheets
    }

}
