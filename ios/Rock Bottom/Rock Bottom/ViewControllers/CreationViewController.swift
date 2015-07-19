//
//  CreationViewController.swift
//  Rock Bottom
//
//  Created by Jerry Chen on 7/18/15.
//  Copyright (c) 2015 Jerry Chen. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class CreationViewController: UIViewController
{
    @IBOutlet weak var rateButton1: UIButton!
    @IBOutlet weak var rateButton2: UIButton!
    @IBOutlet weak var rateButton3: UIButton!
    @IBOutlet weak var rateButton4: UIButton!
    @IBOutlet weak var rateButton5: UIButton!
    @IBOutlet weak var rateButton6: UIButton!
    @IBOutlet weak var rateButton7: UIButton!
    @IBOutlet weak var rateButton8: UIButton!
    @IBOutlet weak var rateButton9: UIButton!
    @IBOutlet weak var rateButton10: UIButton!
    
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var story: Story?
    var rating: Int = 5 // default

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storyTextView.layer.borderWidth = 1
        
        // default rating of 5
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        
        var hideKeyboard: UISwipeGestureRecognizer =
        UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        hideKeyboard.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(hideKeyboard)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPressed(sender: AnyObject)
    {
        story = Story(storyText: storyTextView.text, shittiness: rating)
        
        self.postStory()
        
        self.performSegueWithIdentifier("showStories", sender: nil)
    }
    
    func postStory()
    {
        var request = HTTPTask()
        
        if let story = self.story
        {
            /*println(story.uniqueID)
            println(story.storyText)
            println(story.shittiness)*/
            let params: Dictionary<String, AnyObject> = ["userid": story.userID, "body": story.storyText, "rating": story.shittiness]
            request.POST("http://rockbottom.ml:8888/story/new", parameters: params, completionHandler:
                { (response: HTTPResponse) -> Void in
                    if let err = response.error
                    {
                        println("error: \(err.localizedDescription)")
                    }
                    else
                    {
                        if let dataFromString = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                        {
                            let json = JSON(data: dataFromString)
                            self.story?.storyID = json["id"].intValue
                        }
                    }
                    println("finished posting")
                })
        }
        else
        {
            // error pop up?
        }
    }
    
    func dismissKeyboard()
    {
        self.storyTextView.resignFirstResponder()
    }
    
    
    // MARK: Rating buttons
    
    @IBAction func rate1Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = false
        rateButton3.selected = false
        rateButton4.selected = false
        rateButton5.selected = false
        rateButton6.selected = false
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 1

    }
    
    @IBAction func rate2Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = false
        rateButton4.selected = false
        rateButton5.selected = false
        rateButton6.selected = false
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 2
    }
    
    @IBAction func rate3Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = false
        rateButton5.selected = false
        rateButton6.selected = false
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 3

    }

    @IBAction func rate4Pressed(sender: AnyObject)
    {
        
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = false
        rateButton6.selected = false
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 4

    }
    
    @IBAction func rate5Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = false
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false

        rating = 5
    }
    
    @IBAction func rate6Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = true
        rateButton7.selected = false
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 6

    }
    
    @IBAction func rate7Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = true
        rateButton7.selected = true
        rateButton8.selected = false
        rateButton9.selected = false
        rateButton10.selected = false

        rating = 7
    }
    
    @IBAction func rate8Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = true
        rateButton7.selected = true
        rateButton8.selected = true
        rateButton9.selected = false
        rateButton10.selected = false
        
        rating = 8

    }
    
    @IBAction func rate9Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = true
        rateButton7.selected = true
        rateButton8.selected = true
        rateButton9.selected = true
        rateButton10.selected = false
        
        rating = 9

    }
    
    @IBAction func rate10Pressed(sender: AnyObject)
    {
        rateButton1.selected = true
        rateButton2.selected = true
        rateButton3.selected = true
        rateButton4.selected = true
        rateButton5.selected = true
        rateButton6.selected = true
        rateButton7.selected = true
        rateButton8.selected = true
        rateButton9.selected = true
        rateButton10.selected = true
        
        rating = 10

    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showStories")
        {
            let storiesViewController = segue.destinationViewController as!
                                        StoriesViewController
            
            while(self.story?.storyID == -1) {} // let post finish terribly
            
            storiesViewController.userStory = self.story
            
        }
    }
    

}
