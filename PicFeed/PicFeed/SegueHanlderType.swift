//
//  SegueHanlderType.swift
//  PicFeed
//
//  Created by Ryan David on 2/18/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit


protocol SegueHandlerType
{
    typealias SegueIdentifier: RawRepresentable
    
}
extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String
{
    func performSegueWithIdentifier(identifier: SegueIdentifier, sender: AnyObject)
    {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(identifier: UIStoryboardSegue) -> SegueIdentifier
    {
        guard let identifier = identifier.identifier, rawSegueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("") }
    
        return rawSegueIdentifier
    }
}