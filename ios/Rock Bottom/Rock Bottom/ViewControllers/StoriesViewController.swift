//
//  StoriesViewController.swift
//  Rock Bottom
//
//  Created by Jerry Chen on 7/19/15.
//  Copyright (c) 2015 Jerry Chen. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class StoriesViewController: UIViewController
{
    var userStory: Story?
    var relatedStoriesIds: [Int] = []
    var relatedStories: [String] = []
    var currentStory: Int = 0
    
    var storyBody: String = "-1"
    
    @IBOutlet weak var storyTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

        var myQueue = dispatch_queue_create("com.myexample.MyCustomQueue", nil)
        
        dispatch_sync(myQueue)
        {
            self.getRelatedStoriesIds()
        }
        dispatch_sync(myQueue)
        {
            self.getRelatedStories()
        }
        dispatch_sync(myQueue)
        {
            //self.displayStory(0)
        }
       
    
        var swipeLeft: UISwipeGestureRecognizer =
        UISwipeGestureRecognizer(target: self, action: "getNextStory")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        var swipeRight: UISwipeGestureRecognizer =
        UISwipeGestureRecognizer(target: self, action: "reportWorse")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        storyTextView.editable = true
        storyTextView.font = UIFont.systemFontOfSize(16)
        storyTextView.editable = false
        
        // displayStory(0)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRelatedStoriesIds()
    {
        //println(userStory?.storyID)
        var request = HTTPTask()
        
        request.GET("http://rockbottom.ml:8888/story/"
            + "\(userStory!.storyID)" + "/related", parameters: nil,
            completionHandler:
            { (response: HTTPResponse) -> Void in
                if let err = response.error
                {
                    println("error: \(err.localizedDescription)")
                    return
                }
                else
                {
                    if let dataFromString =
                        response.text?.dataUsingEncoding(NSUTF8StringEncoding,
                        allowLossyConversion: false)
                    {
                        let jsonIds = JSON(data: dataFromString)
                        //println(json)
                        self.relatedStoriesIds = jsonIds["ids"].arrayObject as! [Int]
                        println(self.relatedStoriesIds)
                        
                    }
                }
            })
    }
    
    func getRelatedStories()
    {
        while(relatedStoriesIds.count <= 0) {}
        
        var arr: [String] = []
        
        for(var i=0;i<relatedStoriesIds.count;i++)
        {
            let curId = relatedStoriesIds[i]
            
            let storyRequest = HTTPTask()
            
            storyRequest.GET("http://rockbottom.ml:8888/story/"
                + "\(curId)", parameters: nil,
                completionHandler:
                { (response: HTTPResponse) -> Void in
                    if let err = response.error
                    {
                        println("error: \(err.localizedDescription)")
                        return
                    }
                    else if let dataString = response.text?.dataUsingEncoding(NSUTF8StringEncoding,
                        allowLossyConversion: false)
                    {
                        println(response.text)
                        let json = JSON(dataString)
                        println(json["body"])
                        //println(json["body"].stringValue)
                        arr.append(json["body"].stringValue)
                        
                        println(arr[i])
                    }
            })
        }
        
        relatedStories = arr

    }
    
    
    func displayStory(storyIndex: Int)
    {
        storyTextView.text = relatedStories[storyIndex]
    }
    
    /*func getNextStory()
    {
        var request = HTTPTask()
        var original = self.currentStory
        
        let params: Dictionary<String, AnyObject> = ["userid": userStory?.userID, "compareToid":"\(relatedStories![currentStory])"]
        
        request.POST("http://rockbottom.ml:8888/story"
            + "\(relatedStoriesIds![currentStory])" + "/worse",
            parameters: params,
            completionHandler:
            { (response: HTTPResponse) -> Void in
                if let err = response.error
                {
                    println("error: \(err.localizedDescription)")
                    return
                }
                else
                {
                    self.currentStory++
                }
        })
        
        while(original == self.currentStory) {}
        
        displayStory(currentStory)
    }
    
    func reportWorse()
    {
        var request = HTTPTask()
        var original = self.currentStory
        
        request.POST("http://rockbottom.ml:8888/story"
            + "\(relatedStoriesIds![currentStory])" + "/notasbad",
            parameters: ["aoeu": 2],
            completionHandler:
            { (response: HTTPResponse) -> Void in
                if let err = response.error
                {
                    println("error: \(err.localizedDescription)")
                    return
                }
                else
                {
                    self.currentStory++
                }
        })
        
        while(original == self.currentStory) {}
        
        displayStory(currentStory)
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
