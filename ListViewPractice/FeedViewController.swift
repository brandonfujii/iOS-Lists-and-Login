//
//  FeedViewController.swift
//  ListViewPractice
//
//  Created by Brandon Fujii on 5/7/16.
//  Copyright © 2016 brandonfujii. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UITableViewController {

    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.ITEM_REF.observeEventType(.Value, withBlock: { snapshot in
            
            print("This is the snapshot value: \(snapshot.value)")
            
            self.items = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(key: key, dictionary: postDictionary)
                        
                        print("This is an item: \(item)")
                        // Chronological order
                        self.items.insert(item, atIndex: 0)
                    }
                }
                
            }
            
            // Be sure that the tableView updates when there is new data.
            
            self.tableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        print("This is a table view item: \(item)")
            
        if let cell = tableView.dequeueReusableCellWithIdentifier("ItemCellTableViewCell") as? ItemCellTableViewCell {
            print("Cell condition is firing!")
            cell.configureCell(item)
            print("This is a cell: \(cell)")
            
            return cell
            
        } else {
            
            return ItemCellTableViewCell()
            
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage.
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to Login!
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    

}
