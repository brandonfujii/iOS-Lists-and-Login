//
//  DataService.swift
//  ListViewPractice
//
//  Created by Brandon Fujii on 5/7/16.
//  Copyright © 2016 brandonfujii. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService();
    
    private var baseRef = Firebase(url: "\(BASE_URL)")
    private var userRef = Firebase(url: "\(BASE_URL)/users")
    private var itemRef = Firebase(url: "\(BASE_URL)/items")
    
    var BASE_REF: Firebase {
        return baseRef
    }
    
    var USER_REF: Firebase {
        return userRef
    }
    
    var ITEM_REF: Firebase {
        return itemRef
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        // Add a user
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewJoke(item: Dictionary<String, AnyObject>) {
        // childByAutoId() saves the joke and gives it its own ID.
        
        let newItem = ITEM_REF.childByAutoId()
        newItem.setValue(item)
    }
}