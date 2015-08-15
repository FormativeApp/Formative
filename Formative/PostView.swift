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

class PostView: UIReusableView, UITableViewDataSource, UITextViewDelegate  {

    // MARK: - Outlets
    
    @IBOutlet weak var topColorBar: UIView!
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
    var aspectRatio: Double?
    
    func reset(){
        
        var numFavorites = (post["stars"] as! Array<String>).count
        favoritesView.favoritesLabel.text = "\(numFavorites)"
        if (contains((post["stars"] as! Array<String>),PFUser.currentUser()!["PWDid"] as! String))
        {
            favoritesView.starred = true
        }else{
            favoritesView.starred = false
        }
        
        commentsTableView.hidden = true
        commentTextView.hidden = true
        doneButton.hidden = true
        
        buttonToBottomConstraint.constant = 5
        
        postTextLabel.text = post["text"] as? String
        
        
        var categoryText = (post["tags"] as! NSArray)[0] as? String
        
        if categoryText! != "" {
            categoryLabel.text = categoryText!
        }
        
        if let type = post["type"] as? String {
            if (type == "Question")
            {
                topColorBar.backgroundColor = GlobalColors.formativeBlue
            }
            if (type == "Update")
            {
                topColorBar.backgroundColor = UIColor.clearColor()
            }
            if (type == "Admin")
            {
                topColorBar.backgroundColor = UIColor.blackColor()
            }
        }
        
        var user = (post["user"] as! PFUser)
        profileView.nameLabel.text = user["name"] as? String
        
        if (post["comments"] as! Array<PFObject>).count == 0 {
            commentsString = "Reply"
        }
        else {
            var count = (post["comments"] as! Array<PFObject>).count
            var str = count == 1 ? "Reply" : "Replies"
            commentsString = "\(count) \(str)"
        }
        
        viewCommentsButton.setTitle(commentsString, forState: UIControlState.Normal)
        
        if let file = post["photo"] as? PFFile {
            
            postImage.backgroundColor = UIColor.clearColor()
            postImage.file = file
            
            
            if let aspectRatio = post["aspectRatio"] as? Double {
                var newAspectRatioConstraint = NSLayoutConstraint(
                    item: self.postImage,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: self.postImage,
                    attribute: .Height,
                    multiplier: CGFloat(aspectRatio),
                    constant: CGFloat(0))
                if (aspectRatioConstraint != nil)
                {
                    postImage.removeConstraint(self.aspectRatioConstraint!)
                }
                postImage.addConstraint(newAspectRatioConstraint)
                aspectRatioConstraint = newAspectRatioConstraint
            }
            
            postImage.loadInBackground()
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
        
        var coordinateY = textView.convertPoint(textView.bounds.origin, toView: superTableView).y
        var cell = view.superview?.superview?.superview! as! UITableViewCell
        //superTableView!.scrollToRowAtIndexPath(superTableView!.indexPathForCell(cell)!, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        println(coordinateY)
        superTableView?.setContentOffset(CGPointMake(0, coordinateY-100), animated: true)
        
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

        commentTextView.resignFirstResponder()
        
        if ((post["user"] as! PFUser).objectId! != PFUser.currentUser()!.objectId)
        {
            PFCloud.callFunctionInBackground("commentCreated", withParameters: ["name" : PFUser.currentUser()!["name"] as! String, "creator" : (post["user"] as! PFUser).objectId!, "text" : commentTextView.text])
        }

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
        
        commentTextView.text = "Add a comment"
        
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
        favoritesView.favoritesLabel.text = "\(numFavorites)"
    }
    
    // MARK: - Comments Animation
    
    var commentsHidden = true
    @IBAction func revealOrHideComments(sender: UIButton) {
        if (commentsHidden)
        {
            commentsHidden = false
            sender.setTitle("Hide Replies", forState: UIControlState.Normal)
            commentsTableView.reloadData()
            
            tableViewHeightConstraint.constant = commentsTableView.contentSize.height
            buttonToBottomConstraint.constant = commentTextView.frame.height + tableViewHeightConstraint.constant + 50
            superTableView?.beginUpdates()
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
            
            if (post["comments"] as! Array<PFObject>).count == 0 {
                commentsString = "Reply"
            }
            else {
                var count = (post["comments"] as! Array<PFObject>).count
                var str = count == 1 ? "Reply" : "Replies"
                commentsString = "\(count) \(str)"
            }
            
            sender.setTitle(commentsString, forState: UIControlState.Normal)
            self.commentsTableView.hidden = true
            self.commentTextView.hidden = true
            doneButton.hidden = true
            superTableView?.beginUpdates()

            buttonToBottomConstraint.constant = 5
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
                self.superTableView?.endUpdates()
            }, completion: { (success) -> Void in
            })


        }
        
        
    }
    
    // MARK: - Gesture Recognizers
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
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
