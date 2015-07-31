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


    @IBOutlet weak var postImage: PFImageView!{
        didSet{
            var aspectRatioConstraint = NSLayoutConstraint(
                item: postImage,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: postImage,
                attribute: .Height,
                multiplier: postImage.image!.aspectRatio,
                constant: 0)
            postImage.addConstraint(aspectRatioConstraint)
        }
    }
    
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    
    var superTableView: UITableView? // Table view that the post is in set by FeedViewController
    
    var post: PFObject! {
        didSet{
            postTextLabel.text = post["text"] as? String
            //postImage.file = post["photo"] as? PFFile
            //postImage.loadInBackground()
            
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
        
        commentsTableView.reloadData()
        commentsTableView.setNeedsLayout()
        commentsTableView.layoutIfNeeded()
        commentsTableView.reloadData()
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
