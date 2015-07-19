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
    var relatedStoriesIds: [String]?
    var relatedStories: [String]?
    var currentStory: Int = 0
    
    var idsFound = false
    var storiesFound = false
    
    var storyBody: String = "-1"
    
    @IBOutlet weak var storyTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getRelatedStoriesIds()
        
        getRelatedStories()
        
        displayStory(0)
    
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
        
        relatedStoriesIds = [String]()
        
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
                        //println(jsonIds)
                        self.relatedStoriesIds = (jsonIds["ids"].arrayObject as? [String])
                        println(self.relatedStoriesIds!)
                        self.idsFound = true
                    }
                }
            })
    }
    
    func getRelatedStories()
    {
        while(!idsFound) {}
        
        relatedStories = [String]()
        
        for(var i=0;i<relatedStoriesIds!.count;i++)
        {
            let curId = relatedStoriesIds![i]
            println("http://rockbottom.ml:8888/story/"
                + curId)
            
            let storyRequest = HTTPTask()
            
            storyRequest.GET("http://rockbottom.ml:8888/story/"
                + curId, parameters: nil,
                completionHandler:
                { (response: HTTPResponse) -> Void in
                    if let err = response.error
                    {
                        println("error: \(err.localizedDescription)")
                        return
                    }
                    else
                    {
                        if let dataString =
                            response.text?.dataUsingEncoding(NSUTF8StringEncoding,
                            allowLossyConversion: false)
                        {
                            //println(response.text)
                            let json = JSON(data: dataString)
                            //println(json["body"])
                            self.relatedStories?.append(json["body"].stringValue)
                            
                            //println(self.relatedStories![i])
                        }
                    }
            })
        }
        
        println(self.relatedStories!)
        storiesFound = true

    }
    
    
    func displayStory(storyIndex: Int)
    {
        while(!storiesFound) {}
        
        storyTextView.text = relatedStories![storyIndex]
    }
    
    func getNextStory()
    {
        var request = HTTPTask()
        var original = self.currentStory
        
        let params: Dictionary<String, AnyObject> = ["compareToId": "\(userStory!.storyID)"]
        
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
        
        let params: Dictionary<String, AnyObject> = ["compareToId": "\(userStory!.storyID)"]
        
        request.POST("http://rockbottom.ml:8888/story"
            + "\(relatedStoriesIds![currentStory])" + "/notasbad",
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
