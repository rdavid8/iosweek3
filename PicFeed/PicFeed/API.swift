//
//  API.swift
//  PicFeed
//
//  Created by Ryan David on 2/16/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import Foundation
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
}