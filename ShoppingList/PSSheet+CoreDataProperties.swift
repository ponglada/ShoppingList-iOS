//
//  PSSheet+CoreDataProperties.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/30/16.
//  Copyright © 2016 Somo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PSSheet {

    @NSManaged var name: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var shoppingItems: NSSet?
    @NSManaged var owner: PSUser?
    @NSManaged var members: NSSet?

}
