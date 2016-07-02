//
//  PSSheetTableViewController.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 6/30/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit

class PSSheetTableViewController: UITableViewController {
    
    var sheets: [PSSheet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sheets"

        let dc = PSDataController.sharedInstance
        if dc.loadedFromPersistentStore {
            self.sheets = PSSheet.allSheets()
        } else {
            self.sheets = []
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShoppingListTableViewController.dataReady), name: PSFinishedLoadingFromPersistentStore, object: nil)
        
        self.performSegueWithIdentifier("AutoShow", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sheets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SheetCell", forIndexPath: indexPath)

        // Configure the cell...
        let sheet = self.sheets[indexPath.row]
        cell.textLabel?.text = sheet.name
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowShoppingList" {
            let selectedCell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(selectedCell)
            let selectedSheet = self.sheets[(indexPath?.row)!]
            PSDataController.sharedInstance.currentSheet = selectedSheet
            PSDataController.sharedInstance.saveCurrentState()
        
        }
    }
    
    
    
    // MARK: - Observer
    
    func dataReady() {
        self.sheets = PSSheet.allSheets()
        self.tableView.reloadData()
    }

}
