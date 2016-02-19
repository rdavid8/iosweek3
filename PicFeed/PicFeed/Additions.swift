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

extension FiltersPreviewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCellWithReuseIdentifier("filterCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
        let filter = self.datasource[indexPath.row]
        filter(self.image!, completion: {
            
            filterCell.imageView.image = $0
        
        })
        
       return filterCell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      
        let filterCell = collectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell
        self.delegate?.previewViewControllerDidFinish(filterCell.imageView.image!)
    }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func previewViewControllerDidFinish()
    {
//        self.imageview.image = image.self.dismiss
    }
}

