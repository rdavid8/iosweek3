//
//  Filters.swift
//  PicFeed
//
//  Created by Ryan David on 2/16/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

typealias FiltersCompletion = (theImage: UIImage?) -> ()

class Filters
{
    private class func filter(name: String, image: UIImage, completion: FiltersCompletion)
    {
        NSOperationQueue().addOperationWithBlock { () -> Void in
            guard let filter = CIFilter(name: name) else { fatalError("Check filter spelling") } //CIFilter will returnoptional. name is parameter for filter
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey) //setting an input image for that image
            
            //GPU CONTEXT
            
            let options = [kCIContextWorkingColorSpace : NSNull()]
            let EAGContext = EAGLContext(API: .OpenGLES2)
            let GPUContext = CIContext(EAGLContext: EAGContext, options: options)
            
            //Get the final image. output image of the filter
            guard let outputImage = filter.outputImage else { fatalError("Y no image?") }
            let CGImage = GPUContext.createCGImage(outputImage, fromRect: outputImage.extent)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(theImage: UIImage(CGImage: CGImage))
            })
        }
    }
    
    class func bw(image: UIImage, completion: FiltersCompletion)
    {
        self.filter("CIPhotoEffectMono", image: image, completion: completion)
    }
}

