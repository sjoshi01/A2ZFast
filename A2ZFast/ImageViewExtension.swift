//
//  ImageViewExtension.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 1/25/16.
//  Copyright © 2016 SayaliYogesh. All rights reserved.
//

import Foundation
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}