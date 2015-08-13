//
//  Image Resizer.swift
//  Formative
//
//  Created by Andrew Ke on 8/12/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage
{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    var newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}