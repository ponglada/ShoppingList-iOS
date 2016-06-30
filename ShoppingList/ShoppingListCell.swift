//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/19/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit

class ShoppingListCell: SWTableViewCell {

    var shoppingItem: PSShoppingItem?
    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.10, green: 0.50, blue: 0.50, alpha: 1.0), icon: UIImage(named: "Edit"))
        rightButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.94, green: 0.10, blue: 0.10, alpha: 1.0), icon: UIImage(named: "Delete"))
        
        self.setRightUtilityButtons(rightButtons as [AnyObject], withButtonWidth: 50.0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: PSShoppingItem) {
        self.shoppingItem = item;
        self.itemLabel.text = item.name
    }

}
