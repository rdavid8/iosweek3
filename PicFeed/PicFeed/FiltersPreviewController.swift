//
//  FiltersPreviewController.swift
//  PicFeed
//
//  Created by Ryan David on 2/18/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit
protocol FilterPreviewDelegate: class
{
    func previewViewControllerDidFinish(image: UIImage)
    
}
class FiltersPreviewController: UIViewController, Identity
{
    
    var image: UIImage?
    weak var delegate: FilterPreviewDelegate?
    
    
    var datasource = [Filters.shared.bw, Filters.shared.st, Filters.shared.mc, Filters.shared.px, Filters.shared.ls]
    
    @IBOutlet weak var collectionViewCell: GalleryCollectionViewCell!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    class func id() -> String
    {
        return "FiltersPreviewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupCollectionView()
    {
        self.collectionView.collectionViewLayout = GalleryCustomFlowLayout(columns: 2)
    }
    
}
