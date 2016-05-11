//
//  item.swift
//  ListViewPractice
//
//  Created by Brandon Fujii on 5/7/16.
//  Copyright © 2016 brandonfujii. All rights reserved.
//

import Foundation
import Firebase

class Item {
    private var itemRef: Firebase!
    
    private var _itemKey: String!
    private var _itemContent: String!
    private var _itemVotes: Int!
    private var _username: String!
    
    var itemKey: String {
        return _itemKey
    }
    
    var itemContent: String {
        return _itemContent
    }
    
    var itemVotes: Int {
        return _itemVotes
    }
    
    var username: String {
        return _username
    }
    
    // Initialize an Item
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._itemKey = key
        
        if let votes = dictionary["votes"] as? Int {
            self._itemVotes = votes
        }
        if let item = dictionary["itemContent"] as? String {
            self._itemContent = item
        }
        if let user = dictionary["author"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        self.itemRef = DataService.dataService.ITEM_REF.childByAppendingPath(self._itemKey)
        
    }
    
    func addSubtractVote(addVote: Bool) {
        
        if addVote {
            _itemVotes = _itemVotes + 1
        } else {
            _itemVotes = _itemVotes - 1
        }
        
        itemRef.childByAppendingPath("votes").setValue(_itemVotes)
        
    }
}