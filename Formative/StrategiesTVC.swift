//
//  StrategiesTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/28/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class StrategiesTVC: UITableViewController {
    var strategiesArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuration for dynamic height
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return strategiesArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("strategyCell", forIndexPath: indexPath) as! MultilineCell
        var strategyDictionary = strategiesArray[indexPath.row] as! NSDictionary
        cell.multilineText.text = strategyDictionary["strategy"] as? String
        
        return cell
    }

}
