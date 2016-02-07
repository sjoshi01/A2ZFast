//
//  BaseUIController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/24/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//
import Foundation


class BaseUIController : UIViewController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func SetNavigationBar()
    {
        let navigationBar = self.navigationController?.navigationBar
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 30)!,
            NSBackgroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        navigationBar?.tintColor = UIColor.darkGrayColor()
    }

}


