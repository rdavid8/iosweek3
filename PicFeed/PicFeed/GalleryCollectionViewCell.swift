//
//  GalleryCollectionViewCell.swift
//  PicFeed
//
//  Created by Ryan David on 2/17/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell, Identity
{
    // image view outlet here
    
    @IBOutlet weak var imageView: UIImageView!
    // MARK: Identity
    
    class func id() -> String {
        
        return "GalleryCollectionViewCell"
    }
    var post: Post? {
        didSet {
            self.imageView.image = self.post?.image
            
        }
    }
    
    override func prepareForReuse() 
        {
            super.prepareForReuse()
            self.imageView.image = nil
        }
}
