//
//  JSONManager.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import Foundation

func parseJSON(inputData: NSData) -> NSDictionary{
    var error: NSError?
    let jsonDic = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary;
    
    return jsonDic
}