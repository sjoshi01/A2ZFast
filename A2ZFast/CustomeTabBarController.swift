//
//  CustomeTabBarController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/25/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation
import UIKit

class CustomeTabBarController: UITabBarController
{
    override func viewDidLoad() {
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 14)!
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attrs, forState: .Normal)
        UITabBar.appearance().barTintColor = UIColor.blueColor()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
            }
}
