//
//  PostView.swift
//  
//
//  Created by Andrew Ke on 7/9/15.
//
//

import UIKit
import Bolts
import Parse
import ParseUI

@IBDesignable class PostView: UIReusableView, UITableViewDataSource, UITextViewDelegate  {

    // MARK: - Outlets
    
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var profileView: PostProfileView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var viewCommentsButton: UIButton!
    @IBOutlet weak var favoritesView: PostFavoritesView!
    
    // MARK: - Properties
    var superTableView: UITableView? // Table view that the post is in set by FeedViewController
    var viewController: UIViewController?
    
    var aspectRatioConstraint: NSLayoutConstraint?
    var commentsString: String!
    
    // MARK: - Reuse
    
    var post: PFObject!
    
    func reset(){
        println("reset")
        
        var numFavorites = (post["stars"] as! Array<String>).count
        favoritesView.favoritesLabel.text = "\(numFavorites) Favorites"
        if (contains((post["stars"] as! Array<String>),PFUser.currentUser()!["PWDid"] as! String))
        {
            favoritesView.starred = true
        }
        
        commentsTableView.hidden = true
        commentTextView.hidden = true
        doneButton.hidden = true
        
        buttonToBottomConstraint.constant = 5
        
        postTextLabel.text = post["text"] as? String
        categoryLabel.text = (post["tags"] as! NSArray)[0] as? String
        var user = (post["user"] as! PFUser)
        profileView.nameLabel.text = user["name"] as? String
        
        if (post["comments"] as! Array<PFObject>).count == 0 {
            commentsString = "No Comments (Add your own)"
        }
        else {
            var count = (post["comments"] as! Array<PFObject>).count
            var str = count == 1 ? "Comment" : "Comments"
            commentsString = "\(count) \(str)"
        }
        
        viewCommentsButton.setTitle(commentsString, forState: UIControlState.Normal)
        
        if let file = post["photo"] as? PFFile {
            
            self.postImage.image = nil
            self.postImage.backgroundColor = UIColor.greenColor()
            postImage.file = file
            
            postImage.loadInBackground { (image, error) -> Void in
                var aspectRatioConstraint = NSLayoutConstraint(
                    item: self.postImage,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: self.postImage,
                    attribute: .Height,
                    multiplier: self.postImage.image!.aspectRatio,
                    constant: 0)
                if (self.aspectRatioConstraint != nil)
                {
                    self.postImage.removeConstraint(self.aspectRatioConstraint!)
                }
                self.postImage.addConstraint(aspectRatioConstraint)
                println("snap!")
                self.aspectRatioConstraint = aspectRatioConstraint
                
            }
        }
        else
        {
            self.postImage.image = nil
            var aspectRatioConstraint = NSLayoutConstraint(
                item: self.postImage,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: self.postImage,
                attribute: .Height,
                multiplier: 0,
                constant: 0)
            if (self.aspectRatioConstraint != nil)
            {
                self.postImage.removeConstraint(self.aspectRatioConstraint!)
            }
            self.postImage.addConstraint(aspectRatioConstraint)
            println("snap")
            self.aspectRatioConstraint = aspectRatioConstraint
        }
        
        profileView.profileImage.file = user["profileImage"] as? PFFile
        profileView.profileImage.loadInBackground()
    }
    
    override var className: String {
        get {
            return "PostView"
        }
        set {
            self.className = newValue
        }
    }
    
    // MARK: - Initialization
    func setup(){
        commentsTableView.hidden = true
        commentTextView.hidden = true
        doneButton.hidden = true
        
        buttonToBottomConstraint.constant = 5
        
        commentsTableView.registerNib(UINib(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "commentCell")
        
        commentsTableView.dataSource = self
        
        commentsTableView.estimatedRowHeight = 60
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        
        commentTextView.delegate = self
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        var aspectRatioConstraint = NSLayoutConstraint(
            item: postImage,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: postImage,
            attribute: .Height,
            multiplier: postImage.image!.aspectRatio,
            constant: 0)
        postImage.addConstraint(aspectRatioConstraint)
        
        commentsTableView.hidden = true
        commentTextView.hidden = true
        doneButton.hidden = true
        
        buttonToBottomConstraint.constant = 5
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        
        // Configure placeholder text
        if (commentTextView.text == "Add a comment"){
            textView.text = ""
        }
        
        commentTextView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (commentTextView.text == ""){
            textView.text = "Add a comment"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Parse
    
    @IBAction func postComment() {
        
        if commentTextView.text == "Add a comment" {
            alertErrorWithTitle("Please add a comment body", message: nil, inViewController: viewController!)
            return
        }
        
        var comment = PFObject(className: "Comment")
        comment["text"] = commentTextView.text
        comment["user"] = PFUser.currentUser()!
        post["comments"]  = (post["comments"] as! Array<PFObject>) + [comment]
        commentTextView.text = "Add a comment"
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            self.commentsTableView.reloadData()
            self.superTableView?.beginUpdates()
            
            self.tableViewHeightConstraint.constant = self.commentsTableView.contentSize.height
            self.buttonToBottomConstraint.constant = self.commentTextView.frame.height + self.tableViewHeightConstraint.constant + 50
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
                self.superTableView?.endUpdates()
                }, completion: { (completed) -> Void in
                    self.commentsTableView.hidden = false
                    self.commentTextView.hidden = false
                    self.doneButton.hidden = false
            })
        }
        
    }
    
    @IBAction func starTapped(sender: UITapGestureRecognizer) {
        if (favoritesView.starred)
        {
            favoritesView.starred = false
            post["stars"] = (post["stars"] as! Array<String>).filter({$0 != PFUser.currentUser()!["PWDid"] as! String})
        }else{
            favoritesView.starred = true
            post["stars"] = (post["stars"]! as! Array<String>) + [PFUser.currentUser()!["PWDid"] as! String]
            post.saveInBackground()
        }
        
        var numFavorites = (post["stars"] as! Array<String>).count
        favoritesView.favoritesLabel.text = "\(numFavorites) Favorites"
    }
    
    // MARK: - Comments Animation
    
    var commentsHidden = true
    @IBAction func revealOrHideComments(sender: UIButton) {
        println(post["comments"] as! Array<PFObject>)
        if (commentsHidden)
        {
            commentsHidden = false
            sender.setTitle("Hide Comments", forState: UIControlState.Normal)
            commentsTableView.reloadData()
            
            superTableView?.beginUpdates()
            
            tableViewHeightConstraint.constant = commentsTableView.contentSize.height
            buttonToBottomConstraint.constant = commentTextView.frame.height + tableViewHeightConstraint.constant + 50
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
                self.superTableView?.endUpdates()
                }, completion: { (completed) -> Void in
                    self.commentsTableView.hidden = false
                    self.commentTextView.hidden = false
                    self.doneButton.hidden = false
            })
        }
        else
        {
            commentsHidden = true
            sender.setTitle(commentsString, forState: UIControlState.Normal)
            superTableView?.beginUpdates()
            
            self.commentsTableView.hidden = true
            self.commentTextView.hidden = true
            doneButton.hidden = true
            
            buttonToBottomConstraint.constant = 5
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
                self.superTableView?.endUpdates()
            })
        }
        
        
    }
    
    // MARK: - Gesture Recognizers
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        println("Image Tapped")
        viewController?.performSegueWithIdentifier("goToImage", sender: postImage.image)
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (post["comments"] as! Array<PFObject>).count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTVC
        
        // Configure the cell...
        cell.commentLabel.text = (post["comments"] as! Array<PFObject>)[indexPath.row]["text"] as? String
        var commentPoster = (post["comments"] as! Array<PFObject>)[indexPath.row]["user"] as! PFUser
        cell.profileImage.file = commentPoster["profileImage"] as? PFFile
        cell.profileImage.loadInBackground()
        
        //superTableView?.beginUpdates()
        
        tableViewHeightConstraint.constant = commentsTableView.contentSize.height
        self.superview?.layoutIfNeeded()
        //self.superTableView?.endUpdates()
        
        return cell
    }
    



}

// MARK: - Extensions
extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
