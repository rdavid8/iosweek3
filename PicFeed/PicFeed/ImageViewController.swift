//
//  ViewController.swift
//  PicFeed
//
//  Created by Ryan David on 2/12/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

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


        
//        let bwAction = UIAlertAction(title: "Black & White", style: .Default) { (action) -> Void in
//            Filters.shared.bw(image, completion: { (theImage) -> () in
//            self.imageView.image = theImage
//            })
//        }
//        let stAction = UIAlertAction(title: "Sepia Tone", style: .Default) { (action) -> Void in
//            Filters.shared.st(image, completion: { (theImage) -> () in
//            self.imageView.image = theImage
//            })
//        }
//        let mcAction = UIAlertAction(title: "Monochrome", style: .Default) { (action) -> Void in
//            Filters.shared.mc(image, completion: { (theImage) -> () in
//            self.imageView.image = theImage
//            })
//        }
//            let pxAction = UIAlertAction(title: "Pixellate", style: .Default) { (action) -> Void in
//            Filters.shared.px(image, completion: { (theImage) -> () in
//            self.imageView.image = theImage
//            })
//        }
//            let lsAction = UIAlertAction(title: "Line Screen", style: .Default) { (action) -> Void in
//            Filters.shared.ls(image, completion: { (theImage) -> () in
//            self.imageView.image = theImage
//            })
//        }
//            let reset = UIAlertAction(title: "Reset", style: .Destructive) { (action) -> Void in
//            self.imageView.image = self.originalImage
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//            actionSheet.addAction(bwAction)
//            actionSheet.addAction(stAction)
//            actionSheet.addAction(mcAction)
//            actionSheet.addAction(pxAction)
//            actionSheet.addAction(lsAction)
//            actionSheet.addAction(reset)
//            actionSheet.addAction(cancelAction)
//        
//        self.presentViewController(actionSheet, animated: true, completion: nil)
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

