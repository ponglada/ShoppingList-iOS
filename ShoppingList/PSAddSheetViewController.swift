//
//  PSAddSheetViewController.swift
//  ShoppingList
//
//  Created by Ponglada Pongpattanapan on 7/1/16.
//  Copyright © 2016 Somo. All rights reserved.
//

import UIKit

protocol PSAddSheetDelegate: class {
    func addSheetController(controller: PSAddSheetViewController, didAddedNewSheet sheet: PSSheet)
}

class PSAddSheetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addTextField: UITextField!
    weak var delegate: PSAddSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTextField.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let name = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if name?.characters.count > 0 {
            let user = PSDataController.sharedInstance.currentUser
            let newSheet = PSSheet.newSheet(name!, owner: user!, save: true)
            self.delegate?.addSheetController(self, didAddedNewSheet: newSheet)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
