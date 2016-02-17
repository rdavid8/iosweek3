//
//  API.swift
//  PicFeed
//
//  Created by Ryan David on 2/16/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit
import CloudKit

typealias APICompletion = (success: Bool) -> ()

class API
{
    static let shared = API()
    
    let container: CKContainer
    let database: CKDatabase
    
    private init()
    {
        self.container = CKContainer.defaultContainer()
        self.database = self.container.privateCloudDatabase
    }
    
    func POST(post: Post, completion: APICompletion)
    {
        do {
            if let record = try Post.recordWith(post) {
                
                self.database.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        print(record)
                        completion(success: true)
                    }
                })
                
            }
        } catch let error { print(error) }
    }
    
    func GETPosts(completion: (posts: [Post]?) -> ())
    {
        let query = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
        self.database.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if error == nil {
                
                if let records = records {
                    
                    var posts = [Post]()
                    
                    for record in records {
                        guard let asset = record["image"] as? CKAsset else { return }
                        guard let path = asset.fileURL.path else { return } //
                        guard let image = UIImage(contentsOfFile: path) else { return }
                        posts.append(Post(image: image))
                        
                    }
                    //return on main q
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        
                        completion(posts: posts)
                    })
                    
                }
            } else {
                print(error)
            }
        }
    }
}