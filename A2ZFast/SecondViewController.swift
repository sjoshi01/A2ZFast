//
//  SecondViewController.swift
//  A2ZFast
//
//  Created by Yogesh Hande on 12/23/15.
//  Copyright © 2015 SayaliYogesh. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4
 
class SecondViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var fbLoginBtn: UIButton!

    @IBOutlet var tableFooter: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var scoresTablesView: UITableView!
    @IBOutlet var imgUser: UIImageView!
    var userIds = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoresTablesView.tableFooterView = tableFooter



        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.DisplayUserScore()
        super.viewDidAppear(animated)
        self.currentController = String("Second")
        if self.isFacebookLoginEnabled()
        {
            self.fbLoginBtn.hidden = true
            self.scoresTablesView.hidden = false
            self.DisplayUserInfo()
            self.userIds.removeAll()
            self.fetchAndDisplayUserScores()
        }
        else
        {
            self.scoresTablesView.hidden = true
            self.DisplayUserScore()
            
        }
        
    }

    func isFacebookLoginEnabled() -> Bool
    {
        if let _ = PFUser.currentUser()?.username
        {
            return true;
        }
        return false;
    }
    
    func DisplayUserInfo()
    {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler(
            {
                (connection, result, error) -> Void in
                if error != nil
                {
                    print(error)
                }
                else if let result = result
                {
                    PFUser.currentUser()?["name"] = result["name"]
                    let userId = result["id"] as! String
                    let facebookProfilePicture = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    if let fbpicUrl = NSURL(string: facebookProfilePicture)
                    {
                        if let data = NSData(contentsOfURL: fbpicUrl)
                        {
                            self.imgUser.image = UIImage(data: data)
                        }
                    }
                    self.lblUserName.text = result["name"] as? String
                
                    do
                    {
                        try  PFUser.currentUser()?.save()
                    }
                    catch
                    {
                        print("exception thrown while saving user")
                    }
                }
            })
    }
    
    
    func fetchAndDisplayUserScores()
    {
        let friendsRequest = FBSDKGraphRequest(graphPath: "578230275535360/scores", parameters: ["fields": ""])
        let scoreUtil = ScoreUtility()
        friendsRequest.startWithCompletionHandler{(connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            if let error = error
            {
                print(error)
                return
            }
            let resultdict = result as! NSDictionary
            print("Result Dict: \(resultdict)")
            if let data: NSArray = resultdict.objectForKey("data") as? NSArray
            {
                for i in 0..<data.count
                {
                    let currentUser = User()
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let score = (valueDict.objectForKey("score") as? Int)
                    currentUser.score = scoreUtil.ConvertScoreToString(score!)
                    
                    print(score)
                    let userDict = valueDict.objectForKey("user") as? NSDictionary
                    currentUser.userName = userDict?.objectForKey("name") as? String
                    let userId = userDict?.objectForKey("id") as? String
                    let facebookProfilePicture = "https://graph.facebook.com/" + userId! +  "/picture?type=large"
                    
                    let fbpicUrl = NSURL(string: facebookProfilePicture)
                    currentUser.imageUrl = fbpicUrl
                    self.userIds.append(currentUser)
                }
            }
            self.userIds = self.userIds.reverse()
            dispatch_async(dispatch_get_main_queue())
                {
                    self.scoresTablesView.reloadData()
            }
            let score = self.getScore()
            //self.scoresTablesView.reloadData()
            self.compareAndUpdate(score)
            
        }
    }
    
    func updateFacebookScore(score: Int)
    {
        if(isFacebookLoginEnabled())
        {
            
            let friendsRequest = FBSDKGraphRequest(graphPath: "me/scores", parameters: ["score" : score] , HTTPMethod: "POST")
            friendsRequest.startWithCompletionHandler{(connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                if let error = error
                {
                    print(error)
                    return
                }
            }
            
        }
    }
    
    func reAuthorizeUserForPublishPermission()
    {
       
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(userIds.count)
        return self.userIds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!

        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        cell.textLabel?.text = self.userIds[indexPath.row].userName
    
        cell.imageView!.imageFromUrl((self.userIds[indexPath.row].imageUrl?.absoluteString)!)

        cell.detailTextLabel!.text = self.userIds[indexPath.row].score
        
        return cell
    }
    
    @IBAction func FBSignIn(sender: AnyObject) {
        
        let permissions = ["user_friends"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions , block:
            {
                (user: PFUser? , error: NSError?) -> Void in
                if let error = error
                {
                    print(error)
                }
                else
                {
                    if let _ = user
                    {
                        self.fbLoginBtn.hidden = true
                        self.scoresTablesView.hidden = false
                        self.DisplayUserInfo()
                        self.fetchAndDisplayUserScores()
                    }
                    else
                    {
                        self.scoresTablesView.hidden = false
                    }
                }
        })
    }
    
    func DisplayUserScore()
    {
        let userScore = self.getScore()
        let scoreUtil = ScoreUtility()
        self.scoreLabel.text = scoreUtil.ConvertScoreToString(userScore)

    }
    
    func getScore() -> Int
    {
        let isolatedDataStore = IsolatedDataStore()
        let userScore = isolatedDataStore.GetScore()
        return userScore
    }
    
    func FbSignInWithWritePermissions(score: Int)
    {
        let permissions = ["publish_actions"]
        
        PFFacebookUtils.logInInBackgroundWithPublishPermissions(permissions , block:
            {
                (user: PFUser? , error: NSError?) -> Void in
                if let error = error
                {
                    print(error)
                    return
                }
                
                self.compareAndUpdate(score)
        })
                
    }
    
    func compareAndUpdate(score: Int)
    {
        let localScore = self.getScore()
        var fbScore: Int = 0
        if(isFacebookLoginEnabled())
        {
            let userScore = FBSDKGraphRequest(graphPath: "me/scores", parameters: ["fields" : "score"] , HTTPMethod: "GET")
            userScore.startWithCompletionHandler{(connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                if let error = error
                {
                    print(error)
                    return
                }
            
            let resultdict = result as! NSDictionary
            if let data: NSArray = resultdict.objectForKey("data") as? NSArray
            {
                for i in 0..<data.count
                {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    fbScore = (valueDict.objectForKey("score") as? Int)!
                    print(fbScore)
                }
            }
                
            if fbScore == 0 || fbScore > localScore
            {
                self.updateFacebookScore(localScore)
            }
            else
            {
                var isolatedDataStore = IsolatedDataStore()
                isolatedDataStore.Update(fbScore)
                dispatch_async(dispatch_get_main_queue())
                    {
                        self.DisplayUserScore()
                }
            }

          }
        }
        
    }

}

