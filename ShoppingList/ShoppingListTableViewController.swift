//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/19/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, UITextFieldDelegate, SWTableViewCellDelegate, ShoppinglistCellDelegate {

    var shoppingItems: [PSShoppingItem]!
    var shoppingSheet: PSSheet!
    
    @IBOutlet weak var AddItemTextField: UITextField!
    
    enum RightButtonsIndex: Int {
        case Edit = 0, Delete
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dc = PSDataController.sharedInstance
        if dc.loadedFromPersistentStore {
            self.shoppingSheet = PSDataController.sharedInstance.currentSheet
            self.shoppingItems = self.shoppingSheet.shoppingItems?.allObjects as! [PSShoppingItem]
            self.navigationItem.title = self.shoppingSheet.name!
        } else {
            self.shoppingItems = []
            self.navigationItem.title = ""
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShoppingListTableViewController.dataReady), name: PSFinishedLoadingFromPersistentStore, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.shoppingItems.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddItemCell", forIndexPath: indexPath)
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ShoppingListCell
        
        // Configure the cell...
        cell.setItem(self.shoppingItems[indexPath.row - 1])
        cell.delegate = self
        cell.shoppingCellDelegate = self

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 */
    /*
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit", handler: { (action, indexPath) in
            print("hey")
        })
        
        let action2 = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete", handler: { (action, indexPath) in
            print("ha")
        })
        
        return [action1, action2]
        
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let name: String = (textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!
        
        if name.characters.count > 0 {
            let item = PSShoppingItem.newShoppingItem(textField.text!, inSheet: self.shoppingSheet, save: true)
            self.shoppingItems.append(item)
            textField.text = ""
            
            let indexesPath = [NSIndexPath(forRow:self.shoppingItems.count, inSection: 0)]
            self.tableView.insertRowsAtIndexPaths(indexesPath, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    // MARK: - SWTableViewCell Delegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let shoppingCell = cell as? ShoppingListCell
        let indexPath = self.tableView.indexPathForCell(shoppingCell!)
        
        switch index {
        case RightButtonsIndex.Edit.rawValue:
            self.tableView.scrollEnabled = false
            cell.setEditing(true, animated: true)
            
            
        case RightButtonsIndex.Delete.rawValue:
            
            self.shoppingItems.removeAtIndex((indexPath?.row)! - 1)
            
            let item = shoppingCell?.shoppingItem
            let moc = PSDataController.sharedInstance.managedObjectContext
            moc.deleteObject(item!)
            do {
                try moc.save()
            } catch {
                fatalError("Failed to save context")
            }
            
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        default:
            fatalError("Right Utilitity Button Index out of bound")
        }
    }
    
    func shoppingListCell(cell: ShoppingListCell, didFinishedEditName name: String) {
        let newText = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let indexPath = self.tableView.indexPathForCell(cell)
        let item = self.shoppingItems[(indexPath?.row)! - 1] 
        
        if newText != item.name {
            item.name = newText
            let moc = PSDataController.sharedInstance.managedObjectContext
            do {
                try moc.save()
            } catch {
                fatalError("Failed to save context")
            }
        }
        
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
        self.tableView.scrollEnabled = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Observer
    
    func dataReady() {
        self.shoppingSheet = PSDataController.sharedInstance.currentSheet
        self.shoppingItems = self.shoppingSheet.shoppingItems?.allObjects as! [PSShoppingItem]
        self.navigationItem.title = self.shoppingSheet.name!
        self.tableView.reloadData()
    }

}
