//
//  FeedViewController.swift
//  Formative
//0

//  Created by Andrew Ke on 7/23/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Bolts
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loadingLabel: UILabel! // (At bottom) "Loading more posts ..."
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var mainSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addPostButton: UIButton! // Main bar
    @IBOutlet weak var secondaryAddPostButton: UIButton! // Mini circle
    
    var posts: Array<PFObject> = []
    var user: PFUser!
    
    struct TableViewConstants {
        static let numberOfInitialCells = 4
        static let numberOfCellsPerLoad = 2
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
        println("\(user)")
        user = PFUser.currentUser()
        //user.fetchIfNeeded()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //tableView.estimatedRowHeight = 200.0
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        user = PFUser.currentUser()!
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = TableViewConstants.numberOfInitialCells
        postsQuery.orderByDescending("updatedAt")
        postsQuery.includeKey("user")
        postsQuery.includeKey("comments")
        
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if (objects != nil) {
                
                self.posts = objects as! Array<PFObject>
                //print(self.posts)
                self.tableView.reloadData()
                self.tableView.hidden = false
                self.mainSpinner.stopAnimating()
            }
            else {
                alertErrorWithTitle("No internet connection", message: nil, inViewController: self)
            }
        })
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = TableViewConstants.numberOfInitialCells
        postsQuery.orderByDescending("updatedAt")
        postsQuery.includeKey("user")
        postsQuery.includeKey("comments")
        
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if (objects != nil) {
                
                self.posts = objects as! Array<PFObject>
                //print(self.posts)
                self.tableView.reloadData()
                self.tableView.hidden = false
                refreshControl.endRefreshing()
            }
            else {
                alertErrorWithTitle("No internet connection", message: nil, inViewController: self)
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
        
        var currentOffset = scrollView.contentOffset.y
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset <= 150.0) {
            if (loadInProgress == false){
                loadMorePosts()
                //println("Load!")
                loadInProgress = true
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadInProgress = false
    }
    
    // MARK: - Table view data source
    
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 200
        }
    }*/
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.layoutSubviews()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (posts.count == 0){
            loadingLabel.hidden = true
        }
        else {
            loadingLabel.hidden = false
        }
        return posts.count// > 0 ? posts.count + 1: 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Special Whitespace Cell
        /*if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("whiteSpaceCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }*/

        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTVC
        cell.postView.superTableView = self.tableView
        cell.postView.viewController = self
        var post = posts[indexPath.row]
        cell.postView.post = post
        //cell.postView.aspectRatioConstraint?.constant = 4
        //println(cell.postView.aspectRatioConstraint?.constant)
        //println("Cell created")
        cell.postView.reset()
        return cell
    }
    
    var loadInProgress = false
    
    func loadMorePosts() {
        println("Load more posts")
        loadInProgress = true
        
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        postsQuery.limit = TableViewConstants.numberOfCellsPerLoad
        postsQuery.orderByDescending("updatedAt")
        postsQuery.includeKey("user")
        postsQuery.includeKey("comments")
        postsQuery.whereKey("updatedAt", lessThan: posts[posts.endIndex-1].updatedAt!)
        
        self.loadingLabel.text = "Loading more posts ..."
        
        postsQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if (objects != nil && objects?.count != 0) {
                
                for object in objects as! Array<PFObject> {
                    if !contains(self.posts, object){
                        self.posts.append(object)
                    }
                }
                //var offset = self.tableView.contentOffset
                self.tableView.reloadData()
                self.tableView.layoutSubviews()
                //self.tableView.layoutIfNeeded()
                //self.tableView.reloadData()
                //self.tableView.setContentOffset(offset, animated: false)
                /*var indexPaths: Array<NSIndexPath> = [NSIndexPath(forRow: 2, inSection: 0)]
                
                for i in 1...(objects!.count-1){
                    indexPaths.append(NSIndexPath(forRow: self.posts.count - objects!.count + i, inSection: 1))
                }*/

                /*self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
                self.tableView.endUpdates()*/
            }
            else {
                self.loadingLabel.text = "No more posts to be loaded"
            }
        })
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
