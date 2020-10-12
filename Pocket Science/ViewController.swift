//
//  ViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 31/3/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX
import MotionToastView

class ViewController: UIViewController, dataFromSettings {
        
    // Variables
    var recentlyOpenedTopic:String = LessonsViewController().recentlyOpenedLevel
    var userPoints:Int = 0
    var primaryLevel:String = LessonsViewController().primaryLevel
    var storedUserName:String = ""
    var storedUserAge = ""
    var userSchool:String = ""
    var userRank = ""
    var welcomeMessageShown:Bool = false
    var numOfTimesAppWasOpened = 0
    var earnedAwards:Array<String> = []
    let lowerPriColour = UIColor(red: 117, green: 170, blue: 230, alpha: 1.0)
    let upperPriColour = UIColor(red: 86, green: 146, blue: 229, alpha: 1.0)
    
    let userDefaults = UserDefaults.standard
    
    // Buttons and Labels
    @IBOutlet weak var recentlyOpenedBtn: UIButton!
    @IBOutlet weak var upperPrimaryBtn: UIButton!
    @IBOutlet weak var lowerPrimaryBtn: UIButton!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dismissWelcomeMessage: UIButton!
    @IBOutlet weak var dismissEarnedAward: UIButton!
    
    // Earned Award View
    @IBOutlet weak var awardImgView: UIImageView!
    @IBOutlet weak var awardName: UILabel!
    @IBOutlet weak var awardDiscrip: UILabel!
    
    // Views
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var earnedAwardView: UIView!
    
    // Background Padding
    @IBOutlet weak var bgPad: UILabel!
    
    func passDataBack(settingsUserName: String, settingsUserAge: String) {
        storedUserName = settingsUserName
        storedUserAge = settingsUserAge
    }
    
    // Badge Check
    func checkBadge() {
        if (numOfTimesAppWasOpened >= 10 && earnedAwards.contains("Regular Member")) {
            awardImgView.image = UIImage(named: "Regular Member Badge")
            awardName.text = "Regular Member"
            awardDiscrip.text = "Open the app 10 times"
            earnedAwardView.isHidden = false
            
            earnedAwards.append("Regular Member")
        } else if (numOfTimesAppWasOpened >= 100 && earnedAwards.contains("Frequent Member")) {
            awardImgView.image = UIImage(named: "Frequent Member Badge")
            awardName.text = "Frequent Member"
            awardDiscrip.text = "Open the app 100 times"
            earnedAwardView.isHidden = false
            
            earnedAwards.append("Frequent Member")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get User Points
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        // Set Clip to Bounds
        bgPad.clipsToBounds = true
        welcomeView.clipsToBounds = true
        dismissWelcomeMessage.clipsToBounds = true
        earnedAwardView.clipsToBounds = true
        dismissEarnedAward.clipsToBounds = true
        
        // Curved Edges
        recentlyOpenedBtn.layer.cornerRadius = 20
        upperPrimaryBtn.layer.cornerRadius = 20
        lowerPrimaryBtn.layer.cornerRadius = 20
        bgPad.layer.cornerRadius = 20
        welcomeView.layer.cornerRadius = 20
        dismissWelcomeMessage.layer.cornerRadius = 10
        earnedAwardView.layer.cornerRadius = 20
        dismissEarnedAward.layer.cornerRadius = 10
                        
        // Change Label Text to Data
        pointLabel.text = "\(userPoints) Points"
        
        // Save User Points
        if userPoints != 0 {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        if userRank != "" {
            userDefaults.set(userRank, forKey: "User Rank")
        }
        
        if let userName = userDefaults.string(forKey: "Username") {
            userNameLabel.text = "\(userName)"
            storedUserName = "\(userName)"
        } else {
            userNameLabel.text = "Hello, User"
            storedUserName = "User"
        }
        
        if let userAge = userDefaults.string(forKey: "Userage") {
            storedUserAge = "\(userAge)"
        } else {
            storedUserAge = "NIL"
        }
        
        if let primaryLevel = userDefaults.string(forKey: "Recently Opened") {
            recentlyOpenedTopic = primaryLevel
        }
        
        if let rank = userDefaults.string(forKey: "User Rank") {
            userRank = rank
        }
        
        if let numOfTimes:Int = userDefaults.integer(forKey: "Number Of Times App Opened") {
            numOfTimesAppWasOpened = numOfTimes
        }
        
        // Recently Opened
        if (recentlyOpenedTopic == "Lower Primary" || primaryLevel == "Lower Primary") {
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "5 Chapters"
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = lowerPriColour
            recentlyOpenedBtn.setTitle("", for: .normal)
        } else if (recentlyOpenedTopic == "Upper Primary" || primaryLevel == "Upper Primary") {
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "4 Chapters"
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = lowerPriColour
            recentlyOpenedBtn.setTitle("", for: .normal)
        }
        
        // Check if Welcome Message was shown before
        if let welcomeMessageShownBefore:Bool = userDefaults.bool(forKey: "Welcome Message") {
            welcomeMessageShown = welcomeMessageShownBefore
        }
        if (welcomeMessageShown == false) {
            welcomeView.isHidden = false
        } else {
            welcomeView.isHidden = true
            earnedAwards.append("Beginner Badge")
        }
        
        numOfTimesAppWasOpened += 1
        userDefaults.set(numOfTimesAppWasOpened, forKey: "Number Of Times App Opened")
        
        print("Number of Times App was Opened: \(numOfTimesAppWasOpened)")
        
        checkBadge()
        
        userDefaults.set(earnedAwards, forKey: "Earned Awards")
    }
    
    // Button Config
    @IBAction func goToRecentlyOpened(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
        }
        
    }
    
    @IBAction func dismissAwards(_ sender: Any) {
        earnedAwardView.isHidden = true
    }
    
    @IBAction func dismissWelcomeMessage(_ sender: Any) {
        welcomeMessageShown = true
        userDefaults.set(welcomeMessageShown, forKey: "Welcome Message")
        welcomeView.isHidden = true
    }
    
    @IBAction func goToLowerPrimary(_ sender: Any) {
       let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Lower Primary"
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
        }

    }
    
    @IBAction func goToUpperPrimary(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Upper Primary"
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
        }
        
        lvlLabel.text = "\(recentlyOpenedTopic)"
        lvlLabel.textColor = UIColor(displayP3Red: 96.0, green: 96.0, blue: 96.0, alpha: 1.0)
        topicLabel.textColor = UIColor(displayP3Red: 96.0, green: 96.0, blue: 96.0, alpha: 1.0)
        lvlLabel.alpha = 1
        topicLabel.alpha = 1
        recentlyOpenedBtn.backgroundColor = UIColor(red: 243.0/255.0, green: 223.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        recentlyOpenedBtn.setTitle("", for: .normal)
    }
    
    // Segue Config
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectLessonVC = segue.destination as! ChooseTopicViewController
        
        selectLessonVC.primaryLevel = primaryLevel
        selectLessonVC.userPoints = userPoints
        selectLessonVC.userName = storedUserName
    }
}
