//
//  PSShoppingItem.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/21/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import Foundation
import CoreData

let PSShoppingItemEntityName = "ShoppingItem"

@objc(PSShoppingItem)
class PSShoppingItem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    static func newShoppingItem(name: String, inSheet: PSSheet, save: Bool) -> PSShoppingItem {
        let moc = PSDataController.sharedInstance.managedObjectContext
        let item = NSEntityDescription.insertNewObjectForEntityForName(PSShoppingItemEntityName, inManagedObjectContext: moc) as! PSShoppingItem
        item.sheet = inSheet
        item.name = name
        
        if save {
            do {
                try moc.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            
        }
        
        return item
    }
}
