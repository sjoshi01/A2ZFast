//
//  CustomNavigationController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/24/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController 
{
    
    override func viewDidLoad() {
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 35)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        //UINavigationBar.appearance().barTintColor = UIColor.darkGrayColor()
        UINavigationBar.appearance().barTintColor = UIColor.blueColor()

        navigationBar.topItem?.title = "A2Z Fast"
    }
    
}