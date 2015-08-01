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


    @IBOutlet weak var postImage: PFImageView! {
        didSet{
            
        }
    }
    
    @IBOutlet weak var profileView: PostProfileView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var superTableView: UITableView? // Table view that the post is in set by FeedViewController
    var viewController: UIViewController?
    
    var aspectRatioConstraint: NSLayoutConstraint?
    
    var post: PFObject! {
        didSet{
            postTextLabel.text = post["text"] as? String
            categoryLabel.text = (post["tags"] as! NSArray)[0] as? String
            var user = (post["user"] as! PFUser)
            profileView.nameLabel.text = user["name"] as? String
            
            
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
                    //self.superTableView?.beginUpdates()
                    self.postImage.addConstraint(aspectRatioConstraint)
                    self.aspectRatioConstraint = aspectRatioConstraint
                    //self.superTableView?.endUpdates()
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
                self.aspectRatioConstraint = aspectRatioConstraint
                
            }
            
            profileView.profileImage.file = user["profileImage"] as? PFFile
            profileView.profileImage.loadInBackground()
        }
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
        
        buttonToBottomConstraint.constant = 5
        
        commentsTableView.registerNib(UINib(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "commentCell")
        
        commentsTableView.dataSource = self
        
        commentsTableView.estimatedRowHeight = 60
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        
        commentTextView.delegate = self
        
        /*commentsTableView.reloadData()
        commentsTableView.setNeedsLayout()
        //commentsTableView.layoutIfNeeded()
        commentsTableView.reloadData()*/
    }
    
    func reset(){
        commentsTableView.hidden = true
        commentTextView.hidden = true
        
        buttonToBottomConstraint.constant = 5
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
        
        buttonToBottomConstraint.constant = 5
        
        //postTextView.sizeToFit()
        //messageTextViewHeightConstraint.constant = postTextView.bounds.height-20
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        
        // Configure placeholder text
        if (commentTextView.text == "Add a comment"){
            textView.text = ""
        }
        
        /*commentTextViewHeightConstraint.constant = 80
        buttonToBottomConstraint.constant = 80 + tableViewHeightConstraint.constant + 30
        UIView.animateWithDuration(0.5, animations: {
            self.superview?.layoutIfNeeded()
        })*/
        
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
            postComment()
            return false
        }
        return true
    }
    
    // MARK: - Parse
    func postComment() {
        
    }
    
    // MARK: - Comments Animation
    var commentsHidden = true
    @IBAction func revealOrHideComments(sender: UIButton) {
        if (commentsHidden)
        {
            commentsHidden = false
            sender.setTitle("Collapse 7 Comments", forState: UIControlState.Normal)
            superTableView?.beginUpdates()
            
            tableViewHeightConstraint.constant = commentsTableView.contentSize.height
            buttonToBottomConstraint.constant = commentTextView.frame.height + tableViewHeightConstraint.constant + 30
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
                self.superTableView?.endUpdates()
                }, completion: { (completed) -> Void in
                    self.commentsTableView.hidden = false
                    self.commentTextView.hidden = false
            })
        }
        else
        {
            commentsHidden = true
            sender.setTitle("Show 7 Comments", forState: UIControlState.Normal)
            superTableView?.beginUpdates()
            
            self.commentsTableView.hidden = true
            self.commentTextView.hidden = true
            
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
        return 2
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...

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
