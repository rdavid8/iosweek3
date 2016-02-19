//
//  ViewController.swift
//  PicFeed
//
//  Created by Ryan David on 2/12/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit
import Social

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SegueHandlerType, FilterPreviewDelegate
{
    enum SegueIdentifier: String
    {
        case Preview = "FiltersPreviewController"
    }
    
    var originalImage: UIImage?
    lazy var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        switch self.segueIdentifierForSegue(segue) {
        case .Preview:
            guard let previewViewController = segue.destinationViewController as? FiltersPreviewController else { fatalError("") }
            guard let image = sender as? UIImage else { fatalError("") }
            previewViewController.image = image
            previewViewController.delegate = self
            
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType)
    {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func presentActionSheet()
    {
        let actionSheet = UIAlertController(title: "Source", message: "Please select the source type", preferredStyle: .ActionSheet)
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
    @IBAction func editButtonSelected(sender: AnyObject)
    {

        let alertController = UIAlertController(title: "Filters", message: "No image selected", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(okAction)
        
        guard let image = self.imageView.image else
        {
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        self.performSegueWithIdentifier(.Preview, sender: image)

    }
    
    @IBAction func saveButton(sender: AnyObject)
    {
        guard let image = self.imageView.image else { return }
        API.shared.POST(Post(image: image)) { (success) -> () in
            if success {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil) //specify selector
            }
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) //function to specify
    {
        if error == nil {
            let alertController = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func previewViewControllerDidFinish(image: UIImage)
    {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
        {
            let newPost = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let image = self.imageView.image as UIImage!
            {
                newPost.addImage(image)
                self.presentViewController(newPost, animated: true, completion: nil)
                
            } else { return }
            
        } else {
            
            let alertController = UIAlertController(title: "Failed!", message: "You are not logged in to Twitter", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}


extension ImageViewController
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imageView.image = image
        self.originalImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
  
}

