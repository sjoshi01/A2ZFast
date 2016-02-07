//
//  ScoreUtility.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/28/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import Foundation

public class ScoreUtility
{
    var isolatedDataStore = IsolatedDataStore()
    public func ConvertScoreToString()-> String
    {
        let displayScore = self.isolatedDataStore.GetScore()
        
        let min = Int(displayScore / 60000)
        let sec = Int((displayScore - (min * 60000)) / 1000)
        let millisec = Int ((displayScore - (min * 60000)) % 1000)
        return "\(String(min)):\(String(sec)):\(String(millisec))"
    }
    
    public func ConvertScoreToString(score: Int)-> String
    {
        let min = Int(score / 60000)
        let sec = Int((score - (min * 60000)) / 1000)
        let millisec = Int ((score - (min * 60000)) % 1000)
        return "\(String(min)):\(String(sec)):\(String(millisec))"
    }
    
}
