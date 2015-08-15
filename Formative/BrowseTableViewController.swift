//
//  BrowseTableViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {
    
    // Content of browser.json file used for browse
    var browserContent: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var browerContentData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("browser", ofType: "json")!)
        browserContent = parseJSON(browerContentData!) as! NSArray
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return browserContent.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Contains label and space for background image
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! BrowsePhotoCell
        
        let category = browserContent[indexPath.row] as! NSDictionary
        
        cell.categoryLabel.text = category["title"] as? String
        cell.backgroundImage.image = UIImage(named: category["title"] as! String + ".png")

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var keywordsVC = segue.destinationViewController as! KeywordsTVC
        
        var row = tableView.indexPathForSelectedRow()?.row
        let category = browserContent[row!] as! NSDictionary
        
        keywordsVC.keywordsArray = category["keywords"] as! NSArray
        keywordsVC.title = category["title"] as? String
        
    }

}
