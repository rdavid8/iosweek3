//
//  ViewController.swift
//  PicFeed
//
//  Created by Ryan David on 2/12/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    lazy var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType)
    {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func presentActionSheet()
    {
        let actionSheet = UIAlertController(title: "Source", message: "pleaseselect the sorurce type", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            self.presentImagePicker(.Camera)
            
        }
        
        let photoAction = UIAlertAction(title: "Photos", style: .Default) { (action) -> Void in
            self.presentImagePicker(.PhotoLibrary)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    @IBAction func addButton(sender: AnyObject) {
    
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            self.presentActionSheet()
            
        } else {
            
            self.presentImagePicker(.PhotoLibrary)
        }
        
    }
}

extension ImageViewController
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
