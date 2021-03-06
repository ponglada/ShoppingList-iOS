//
//  PSShoppingItem+CoreDataProperties.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/21/16.
//  Copyright © 2016 Somo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PSShoppingItem {

    @NSManaged var name: String?
    @NSManaged var purchased: NSNumber?
    @NSManaged var sheet: PSSheet?

}
