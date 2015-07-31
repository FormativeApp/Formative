//
//  FeedViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/23/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Bolts
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPostButton: UIButton! // Main bar
    @IBOutlet weak var secondaryAddPostButton: UIButton! // Mini circle
    
    var posts: Array<PFObject> = []
    var user: PFUser!
    
    override func viewDidLoad() {
        tableView.hidden = true
        super.viewDidLoad()
        
        
        self.secondaryAddPostButton.alpha = 0
        
        if (PFUser.currentUser() == nil){
            println("Auto logging in!")
            PFUser.logInWithUsername("andrew@andrewke.org", password: "andrew")
        }

        
        user = PFUser.currentUser()
        
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = 10
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            if (objects != nil) {
                self.posts = objects as! Array<PFObject>
                print(self.posts)
                self.tableView.reloadData()
                self.tableView.hidden = false
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK: - Scroll view data source
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 30 && addPostButton.alpha != 1)
        {
            UIView.animateWithDuration(0.25, animations: {
                self.addPostButton.alpha = 1
                self.secondaryAddPostButton.alpha = 0
            })
        }
        
        if (scrollView.contentOffset.y >= 30 && addPostButton.alpha != 0)
        {
            UIView.animateWithDuration(0.25, animations: {
                self.addPostButton.alpha = 0
                self.secondaryAddPostButton.alpha = 0.6
            })
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count > 0 ? posts.count + 2 : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Special cells
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("whiteSpaceCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        if (indexPath.row == posts.count+1)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("spinnerCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTVC
        cell.postView.superTableView = self.tableView
        cell.postView.post = posts[indexPath.row-1]
        // Configure the cell...
        //cell.layoutIfNeeded()
        return cell
    }
    
    

}
