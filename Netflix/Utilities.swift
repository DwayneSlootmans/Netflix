//
//  Utilities.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import Foundation
import UIKit

extension NSDictionary {
    
    func getStringValueFromJSON(identifier: String) -> String {
        if let value = self["\(identifier)"] as? String {
            return value
        }
        return ""
    }
    
    func getIntValueFromJSON(identifier: String) -> Int {
        if let value = self["\(identifier)"] as? String {
            if let intValue = Int(value) {
                return intValue
            }
        }
        return 0
    }
}

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}