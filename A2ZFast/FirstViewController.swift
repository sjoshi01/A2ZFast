//
//  FirstViewController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/23/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: BaseUIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var textBlockControl: UITextField!
    @IBOutlet var timerLabel: UILabel!
    var player : AVAudioPlayer = AVAudioPlayer()
    
    //Instance Variables
    var xFromCenter: CGFloat = 0
    var isFirstTime = true;
    var CorrectColor = UIColor.greenColor()
    var WrongColor = UIColor.redColor()
    var NewScore = 0
    var isGameStarted = false;
    var timer = NSTimer()
    var sec = 0
    var min = 0
    var msec = 0
    var alphabates = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var currentIndex = 0
    var isolatedDataStore = IsolatedDataStore()
    var scoreUtil = ScoreUtility()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isolatedDataStore.InitializeScore()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.StopGame()
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.currentController = String("First")
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TextFieldTextChanged(sender: UITextField) {
        self.textLabel.text = textBlockControl.text!.capitalizedString
        self.textLabel.slideInFromLeft(0.3, completionDelegate: self)
        self.textBlockControl.text = "";
        if (textLabel.text == alphabates[currentIndex])
        {
            self.EnteredCorrectAlphabate()
        }
        else
        {
            self.EnteredWrongAlphabate()
        }

    }
   
    @IBAction func StartClicked(sender: AnyObject) {
        self.startButton.slideInFromLeft(0.5, completionDelegate: self)
        if(isGameStarted == false)
        {
            self.StartGame()
        }
        else
        {
            self.StopGame()
        }

    }
    
    
    func StartGame()
    {
        self.isGameStarted = true;
        self.startButton.setTitle("Stop", forState: UIControlState.Normal)
        self.textBlockControl.hidden=true
        self.textBlockControl.becomeFirstResponder()
        
    }
    
    func StopGame()
    {
        self.ResetAll()
        self.textBlockControl.resignFirstResponder()
        self.timer.invalidate()
    }
    
    //This method will have all the variables that should be reset
    func ResetAll()
    {
        self.currentIndex = 0
        self.sec = 0
        self.min = 0
        self.msec = 0
        self.isGameStarted = false;
        self.textBlockControl.text = "";
        self.textLabel.text = ""
        self.startButton.setTitle("Start", forState: UIControlState.Normal)
        self.isFirstTime = true;
    }
    
    func EnteredCorrectAlphabate()
    {
        if(self.isFirstTime)
        {
           timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: ("TimerTick"), userInfo: nil, repeats: true)
            self.isFirstTime = false;
        }
        self.textLabel.textColor = self.CorrectColor
        if(currentIndex >= 25)
        {
            
            self.GameCompleted()
            self.StopGame()
            return
        }
        self.PlaySound("correct")
        self.currentIndex++;
        
    }
    
    func PlaySound(fileName : String)
    {
        let audioPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!
        
        do
        {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            player.play()
        }
        catch
        {
            
        }

    }
    
    func EnteredWrongAlphabate()
    {
        self.PlaySound("wrong")
        self.textLabel.textColor = self.WrongColor
    }
    
    func GameCompleted()
    {
        self.PlaySound("completion")
        self.textLabel.text = "Type"
        self.UpdateScore()
        //Game completed the game store the Score and stuff.
    }
    
    func UpdateScore()
    {
        NewScore = (60000 * min) + (1000 * sec) + msec
        
        if(NewScore < self.isolatedDataStore.GetScore())
        {
            self.isolatedDataStore.Update(NewScore)
        }
    }
    
    func UpdateToFacebook()
    {
        
    }
    
    //Timer Methods
    func TimerTick()
    {
        msec++
        
        if(msec == 100)
        {
            msec = 0
            sec++
        }
        if sec == 60
        {
            min++
            sec = 0
        }
        if min >= 5
        {
            self.StopGame()
            self.timer.invalidate()
        }
        DisplayTimer()
    }
    
    func DisplayTimer()
    {
        let strMsec = String(msec)
        let strSec = String(sec)
        let strMin = String(min)
        timerLabel.text = "\(strMin):\(strSec):\(strMsec)"
    }
    
    func FadeIn(target : UIView)
    {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                target.alpha = 1.0
            }, completion: { (finished : Bool) -> Void in
                if self.currentController == "First" {

                self.FadeOut(target)
                }
                })
        
    }

    func FadeOut(target : UIView)
    {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            target.alpha = 0.2
            }, completion: {(finished : Bool) -> Void in
                if self.currentController == "First"{

                self.FadeIn(target)
                }
        })
    }
}

