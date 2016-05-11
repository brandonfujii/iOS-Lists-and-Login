//
//  AddItemViewController.swift
//  ListViewPractice
//
//  Created by Brandon Fujii on 5/8/16.
//  Copyright © 2016 brandonfujii. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController {

    var currentUsername = ""
    
    @IBOutlet weak var itemField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItem(sender: AnyObject) {
        let itemText = itemField.text
        
        if itemText != "" {
            
            // Build the new Joke.
            // AnyObject is needed because of the votes of type Int.
            
            let newItem: Dictionary<String, AnyObject> = [
                "itemContent": itemText!,
                "votes": 0,
                "author": currentUsername
            ]
            
            // Send it over to DataService to seal the deal.
            
            DataService.dataService.createNewJoke(newItem)
            
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }

    }
}
