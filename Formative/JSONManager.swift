//
//  JSONManager.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import Foundation

func parseJSON(inputData: NSData) -> AnyObject{
    var error: NSError?
    let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.AllowFragments, error: nil);
    return parsed!
}
