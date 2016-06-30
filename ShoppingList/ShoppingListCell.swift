//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/19/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit

protocol ShoppinglistCellDelegate: class {
    func shoppingListCell(cell: ShoppingListCell, didFinishedEditName name: String)
}

class ShoppingListCell: SWTableViewCell, UITextFieldDelegate {

    var shoppingItem: PSShoppingItem?
    weak var shoppingCellDelegate: ShoppinglistCellDelegate?
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.editTextField.hidden = true
        self.editTextField.delegate = self
        
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.10, green: 0.50, blue: 0.50, alpha: 1.0), icon: UIImage(named: "Edit"))
        rightButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.94, green: 0.10, blue: 0.10, alpha: 1.0), icon: UIImage(named: "Delete"))
        
        self.setRightUtilityButtons(rightButtons as [AnyObject], withButtonWidth: 50.0)
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.editTextField.text = self.itemLabel.text
            self.editTextField.alpha = CGFloat(0.0)
            self.editTextField.hidden = false
            UIView.animateWithDuration(0.10, animations: {
                self.hideUtilityButtonsAnimated(false)
                self.editTextField.alpha = CGFloat(1.0)
                }, completion: { (Bool) in
                    self.editTextField.becomeFirstResponder()
            })
        
        } else {
            self.editTextField.hidden = true
            self.editTextField.resignFirstResponder()
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: PSShoppingItem) {
        self.shoppingItem = item;
        self.itemLabel.text = item.name
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.editing {
            self.setEditing(false, animated: false)
            self.shoppingCellDelegate?.shoppingListCell(self, didFinishedEditName: self.editTextField.text!)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if self.editing {
            self.setEditing(false, animated: false)
            self.shoppingCellDelegate?.shoppingListCell(self, didFinishedEditName: self.editTextField.text!)
        }
        return true
    }

}
