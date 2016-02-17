//
//  ModelAdditions.swift
//  PicFeed
//
//  Created by Ryan David on 2/16/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit
import CloudKit

enum PostError: ErrorType
{
    case WritingImage
    case CreatingCKRecord
}

extension Post
{
    class func recordWith(post: Post) throws -> CKRecord?
    {
        let imageURL = NSURL.imageURL()
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else { throw PostError.WritingImage }
        let saved = data.writeToURL(imageURL, atomically: true) //imageURL is a directory
        
        if saved {
            let asset = CKAsset(fileURL: imageURL) //requires imageURL (write image file to system)
            let record = CKRecord(recordType: "Post") // name of record in cloudkit dashboard
            record.setObject(asset, forKey: "image") //key for ckasset
            
            return record
        } else { throw PostError.CreatingCKRecord }
    }
}