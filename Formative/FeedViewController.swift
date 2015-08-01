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
    
    struct TableViewConstants {
        static let numberOfCellsPerLoad = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.hidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.secondaryAddPostButton.alpha = 0
        
        if (PFUser.currentUser() == nil){
            println("Auto logging in!")
            PFUser.logInWithUsername("andrew@andrewke.org", password: "andrew")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        user = PFUser.currentUser()
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = TableViewConstants.numberOfCellsPerLoad
        postsQuery.orderByDescending("updatedAt")
        postsQuery.includeKey("user")
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            if (objects != nil) {
                self.posts = objects as! Array<PFObject>
                print(self.posts)
                self.tableView.reloadData()
                self.tableView.hidden = false
            }
        })
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = TableViewConstants.numberOfCellsPerLoad
        postsQuery.orderByDescending("updatedAt")
        postsQuery.includeKey("user")
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            if (objects != nil) {
                self.posts = objects as! Array<PFObject>
                //print(self.posts)
                self.tableView.reloadData()
                self.tableView.hidden = false
                refreshControl.endRefreshing()
            }
        })
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
        
        //var image = UIImage(data: (posts[indexPath.row-1]["photo"] as! PFFile).getData()!)
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTVC
        cell.postView.superTableView = self.tableView
        cell.postView.viewController = self
        cell.postView.post = posts[indexPath.row-1]
        cell.postView.reset()
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == posts.count+1){
            println("reached end")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToImage")
        {
            let vc = segue.destinationViewController as! UINavigationController
            let imageVC = vc.viewControllers[0] as! ImageViewController
            imageVC.image = sender as? UIImage
        }
    }
    
    

}
