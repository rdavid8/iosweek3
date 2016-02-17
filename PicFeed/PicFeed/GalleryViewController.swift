//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Ryan David on 2/17/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var datasource = [Post]()
        {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery"
        self.collectionView.collectionViewLayout = GalleryCustomFlowLayout()
        // Do view setup here.
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.update()
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func update()
    {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        API.shared.GETPosts { (posts) -> () in
            
            if let posts = posts
            {
                self.datasource = posts
                self.navigationItem.rightBarButtonItem = nil
                
            } else { print("No posts...")
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.datasource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let galleryCell = collectionView.dequeueReusableCellWithReuseIdentifier("galleryCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
        
        galleryCell.post = self.datasource[indexPath.row] //referencing the data from datasource
        return galleryCell
    }
    
}