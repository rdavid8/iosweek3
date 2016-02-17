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
    var originalImage: UIImage?
    lazy var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.setupAppearance()
        //        let filterNames = CIFilter.filterNamesInCategory(kCICategoryBuiltIn) as [String]
        //        print(filterNames)
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
        guard let image = self.imageView.image else { return }
        
        let actionSheet = UIAlertController(title: "Filters", message: "Please select a filter", preferredStyle: .ActionSheet)
        
        let bwAction = UIAlertAction(title: "Black & White", style: .Default) { (action) -> Void in
            Filters.bw(image, completion: { (theImage) -> () in
            self.imageView.image = theImage
            })
        }
        let stAction = UIAlertAction(title: "Sepia Tone", style: .Default) { (action) -> Void in
            Filters.st(image, completion: { (theImage) -> () in
            self.imageView.image = theImage
            })
        }
        let mcAction = UIAlertAction(title: "Monochrome", style: .Default) { (action) -> Void in
            Filters.mc(image, completion: { (theImage) -> () in
            self.imageView.image = theImage
            })
        }
            let pxAction = UIAlertAction(title: "Pixellate", style: .Default) { (action) -> Void in
            Filters.px(image, completion: { (theImage) -> () in
            self.imageView.image = theImage
            })
        }
            let lsAction = UIAlertAction(title: "Line Screen", style: .Default) { (action) -> Void in
            Filters.ls(image, completion: { (theImage) -> () in
            self.imageView.image = theImage
            })
        }
            let reset = UIAlertAction(title: "Reset", style: .Destructive) { (action) -> Void in
            self.imageView.image = self.originalImage
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
            actionSheet.addAction(bwAction)
            actionSheet.addAction(stAction)
            actionSheet.addAction(mcAction)
            actionSheet.addAction(pxAction)
            actionSheet.addAction(lsAction)
            actionSheet.addAction(reset)
            actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
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
}
extension ImageViewController
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imageView.image = image
        self.originalImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

