//
//  KeywordsTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class KeywordsTVC: UITableViewController {
    
    var keywordsArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set back button for Strategies TVC
        let backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("keywordCell", forIndexPath: indexPath) as! UITableViewCell
        var keywordDictionary = keywordsArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = keywordDictionary["title"] as? String
    
        return cell
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var strategiesVC = segue.destinationViewController as! StrategiesTVC
        var row = tableView.indexPathForSelectedRow()?.row
        var keywordDictionary = keywordsArray[row!] as! NSDictionary
        strategiesVC.strategiesArray = keywordDictionary["strategies"] as! NSArray
        
        strategiesVC.title = self.title
        strategiesVC.navigationItem.leftBarButtonItem?.title = "Back"
        
    }
    

}
