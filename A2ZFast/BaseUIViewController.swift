//
//  BaseUIViewController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/24/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController
{
    var currentController = String("First")

   //hiding battery,carrier etc. sybols from statusbar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func UIColorFromRGB(rgb: Int, alpha: Float) -> UIColor {
        let red = CGFloat(Float(((rgb>>16) & 0xFF)) / 255.0)
        let green = CGFloat(Float(((rgb>>8) & 0xFF)) / 255.0)
        let blue = CGFloat(Float(((rgb>>0) & 0xFF)) / 255.0)
        let alpha = CGFloat(alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
