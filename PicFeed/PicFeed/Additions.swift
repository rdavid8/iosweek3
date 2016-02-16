//
//  Additions.swift
//  PicFeed
//
//  Created by Ryan David on 2/16/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

extension UIImage
{
    class func resize(image: UIImage, size: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        defer { UIGraphicsEndImageContext() }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension NSURL
{
    class func imageURL() -> NSURL //physically store image before upload
    {
        guard let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else { fatalError() }
        return documentsDirectory.URLByAppendingPathComponent("image")
    }
}