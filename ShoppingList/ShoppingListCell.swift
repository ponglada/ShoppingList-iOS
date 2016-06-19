//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/19/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    var shoppingItem: ShoppingItem?
    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: ShoppingItem) {
        self.shoppingItem = item;
        self.itemLabel.text = item.name
    }

}
