//
//  IsolatedDataStore.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/28/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation

public class IsolatedDataStore
{
    //Constant MaxScore
    var MaxScore = 3000000
    
    public func InitializeScore()
    {
        if (NSUserDefaults.standardUserDefaults().integerForKey("CurrentScore") == 0)
        {
            NSUserDefaults.standardUserDefaults().setInteger(MaxScore, forKey: "CurrentScore")
        }
    }
    
    public func GetScore() ->Int
    {
        return NSUserDefaults.standardUserDefaults().integerForKey("CurrentScore")
    }
    
    public func Update(score: Int)
    {
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "CurrentScore")
    }
}

