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

        user = PFUser.currentUser()
        user.fetchIfNeededInBackground()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        user = PFUser.currentUser()!
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        
        let adminPostsQuery = PFQuery(className: "Post")
        adminPostsQuery.whereKey("recipientID", equalTo: "admin")
        
        let combinedQuery = PFQuery.orQueryWithSubqueries([adminPostsQuery, postsQuery])
        
        combinedQuery.limit = TableViewConstants.numberOfInitialCells
        combinedQuery.orderByDescending("updatedAt")
        combinedQuery.includeKey("user")
        combinedQuery.includeKey("comments")
        
        combinedQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
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
        user = PFUser.currentUser()!
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        
        let adminPostsQuery = PFQuery(className: "Post")
        adminPostsQuery.whereKey("recipientID", equalTo: "admin")
        
        let combinedQuery = PFQuery.orQueryWithSubqueries([adminPostsQuery, postsQuery])
        
        combinedQuery.limit = TableViewConstants.numberOfInitialCells
        combinedQuery.orderByDescending("updatedAt")
        combinedQuery.includeKey("user")
        combinedQuery.includeKey("comments")
        
        combinedQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
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
            if (loadInProgress == false && posts.count > 0){
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
        
        user = PFUser.currentUser()!
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("recipientID", equalTo: user["PWDid"]!)
        
        let adminPostsQuery = PFQuery(className: "Post")
        adminPostsQuery.whereKey("recipientID", equalTo: "admin")
        
        let combinedQuery = PFQuery.orQueryWithSubqueries([adminPostsQuery, postsQuery])
        
        combinedQuery.limit = TableViewConstants.numberOfCellsPerLoad
        combinedQuery.orderByDescending("updatedAt")
        combinedQuery.includeKey("user")
        combinedQuery.includeKey("comments")
        combinedQuery.whereKey("updatedAt", lessThan: posts[posts.endIndex-1].updatedAt!)
        
        self.loadingLabel.text = "Loading more posts ..."
        
        combinedQuery.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if (objects != nil && objects?.count != 0) {
                
                println("\(objects?.count)")
                for object in objects as! Array<PFObject> {
                    if !contains(self.posts, object){
                        self.posts.append(object)
                    }
                }
                println(self.posts.count)
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
