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
    var smallView = GalleryCustomFlowLayout(columns: 4)
    var mediumView = GalleryCustomFlowLayout(columns: 3)
    var largeView = GalleryCustomFlowLayout(columns: 2)
    
    
    
    @IBAction func gestureRecognizer(sender: UIPinchGestureRecognizer)
    {
        
        if sender.state == .Began {
            if sender.velocity > 0 {
                if self.collectionView.collectionViewLayout == self.smallView
                {
                    self.collectionView.collectionViewLayout = self.mediumView
                } else if self.collectionView.collectionViewLayout == self.mediumView
                {
                    self.collectionView.collectionViewLayout = self.largeView
                } else {
                    self.collectionView.collectionViewLayout = self.largeView
                }
            } else {
                if self.collectionView.collectionViewLayout == self.largeView
                {
                    self.collectionView.collectionViewLayout = self.mediumView
                } else if self.collectionView.collectionViewLayout == self.mediumView
                {
                    self.collectionView.collectionViewLayout = self.smallView
                } else {
                    self.collectionView.collectionViewLayout = self.smallView
                }
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