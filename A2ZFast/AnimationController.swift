//
//  AnimationController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/29/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation
import UIKit

class AnimationController : UIView
{
    func FadeIn()
    {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func FadeOut()
    {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}
