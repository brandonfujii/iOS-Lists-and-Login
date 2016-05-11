//
//  ItemCellTableViewCell.swift
//  ListViewPractice
//
//  Created by Brandon Fujii on 5/8/16.
//  Copyright © 2016 brandonfujii. All rights reserved.
//

import UIKit
import Firebase

class ItemCellTableViewCell: UITableViewCell {
    @IBOutlet weak var cellText: UITextView!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var upvote: UIImageView!
    
    var item: Item!
    var voteRef: Firebase!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        upvote.addGestureRecognizer(tap)
        upvote.userInteractionEnabled = true
    }
    
    func configureCell(item: Item) {
        self.item = item
        
        // Set the labels and textView.
        
        self.cellText.text = item.itemContent
        self.voteCount.text = "Total Votes: \(item.itemVotes)"
        self.usernameLabel.text = item.username
        
        voteRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("votes").childByAppendingPath(item.itemKey)
        
        // observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device.
        
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Set the thumb image.
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                
                // Current user hasn't voted for the joke... yet.
                
                print(thumbsUpDown)
                self.upvote.image = UIImage(named: "upvote_notselected")
            } else {
                
                // Current user voted for the joke!
                
                self.upvote.image = UIImage(named: "upvote_selected")
            }
        })
    }
    
    func voteTapped(sender: UITapGestureRecognizer) {
        
        // observeSingleEventOfType listens for a tap by the current user.
        
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                print(thumbsUpDown)
                self.upvote.image = UIImage(named: "upvote_notselected")
                
                // addSubtractVote(), in Joke.swift, handles the vote.
                
                self.item.addSubtractVote(true)
                
                // setValue saves the vote as true for the current user.
                // voteRef is a reference to the user's "votes" path.
                
                self.voteRef.setValue(true)
            } else {
                self.upvote.image = UIImage(named: "upvote_selected")
                self.item.addSubtractVote(false)
                self.voteRef.removeValue()
            }
            
        })
    }
}
