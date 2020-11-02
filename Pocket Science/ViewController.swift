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
import SwiftDate

class ViewController: UIViewController, dataFromSettings {
        
    // Variables
    var recentlyOpenedTopic:String = LessonsViewController().recentlyOpenedLevel
    var recentlyOpenedDate:String = ""
    var userPoints:Int = 0
    var primaryLevel:String = LessonsViewController().primaryLevel
    var storedUserName:String = ""
    var storedUserAge = ""
    var userSchool:String = ""
    var userRank = ""
    var welcomeMessageShown:Bool = false
    var numOfTimesAppWasOpened = 0
    var earnedAwards:Array<String> = []
    let date = Date()
    var newDate = ""
    var dailyStreak = 0
    var earnedImage = ["Beginner Badge", "Bookworm Badge", "Brainy Badge", "Diligent Ant Badge", "Expert Badge", "Frequent Member Badge", "Industrious Bee Badge", "Maestro Badge", "Normal Member Badge", "Perfectionist Badge", "Regular Member Badge","Star Collector Badge","Streaker Bronze Badge","Streaker Gold Badge", "Streaker Silver Badge"]
    
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
    @IBOutlet weak var lastOpenedDateLabel: UILabel!
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
    
    func checkRecentlyOpened() {
        if (recentlyOpenedTopic == "Lower Primary" || primaryLevel == "Lower Primary") {
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "5 Chapters"
            lastOpenedDateLabel.text = recentlyOpenedDate
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            lastOpenedDateLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = UIColor(red: 117/255, green: 170/255, blue: 230/255, alpha: 1.0)
            recentlyOpenedBtn.setTitle("", for: .normal)
        } else if (recentlyOpenedTopic == "Upper Primary" || primaryLevel == "Upper Primary") {
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "4 Chapters"
            lastOpenedDateLabel.text = recentlyOpenedDate
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            lastOpenedDateLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = UIColor(red: 86/255, green: 146/255, blue: 229/255, alpha: 1.0)
            recentlyOpenedBtn.setTitle("", for: .normal)
        }
    }
    
    func checkAwards() {
        if (numOfTimesAppWasOpened == 10) {
            earnedAwards.append("Regular Member")
        } else if (numOfTimesAppWasOpened == 100) {
            earnedAwards.append("Frequent Member")
        }
        
        userDefaults.set(earnedAwards, forKey: "Earned Awards")
    }
    
    func showNewAwardView(award: String) {
        earnedAwardView.isHidden = false
        awardName.text = award
        
    }
    
    func dailyStreakCheck() {
        let currentDate = Date()
        var lastLoginDate:Date
        
        if let lastLogin = userDefaults.object(forKey: "Last Login Date") as? Date {
            lastLoginDate = lastLogin
        } else {
            return
        }
        
        if let streak:Int = userDefaults.integer(forKey: "Daily Streak") {
            dailyStreak = streak
        } else {
            dailyStreak = 0
        }
        
        print(currentDate)
        print(lastLoginDate)
        
        if (currentDate.compare(.isToday) && lastLoginDate.compare(.isYesterday)) {
            dailyStreak += 1
            lastLoginDate = currentDate
            userDefaults.set(dailyStreak, forKey: "Daily Streak")
            userDefaults.set(lastLoginDate, forKey: "Last Login Date")
        } else if (currentDate.compare(.isToday) && lastLoginDate.compare(.isToday)) {
            lastLoginDate = currentDate
            userDefaults.set(dailyStreak, forKey: "Daily Streak")
            userDefaults.set(lastLoginDate, forKey: "Last Login Date")
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newDate = date.toFormat("dd MMM yyyy',' HH:mm")
        
        // Get User Points
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
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
        
        if let userBadges = userDefaults.object(forKey: "Earned Awards") as? Array<String> {
            earnedAwards = userBadges
        }
        
        if let lastOpenedDate = userDefaults.string(forKey: "Recently Opened Date") {
            recentlyOpenedDate = lastOpenedDate
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
                
        if let numOfTimes:Int = userDefaults.integer(forKey: "Number Of Times App Opened") {
            numOfTimesAppWasOpened = numOfTimes
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
        
        dailyStreakCheck()
        checkRecentlyOpened()
        checkAwards()
}
    
    // Button Config
    @IBAction func goToRecentlyOpened(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        recentlyOpenedTopic = primaryLevel
        recentlyOpenedDate = newDate
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
            userDefaults.set(primaryLevel, forKey: "Recently Opened Date")
        }
        
    }
    
    @IBAction func dismissWelcomeMessage(_ sender: Any) {
        welcomeMessageShown = true
        userDefaults.set(welcomeMessageShown, forKey: "Welcome Message")
        welcomeView.isHidden = true
    }
    
    @IBAction func goToLowerPrimary(_ sender: Any) {
       let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Lower Primary"
        recentlyOpenedDate = newDate
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
            userDefaults.set(primaryLevel, forKey: "Recently Opened Date")
        }

        checkRecentlyOpened()
    }
    
    @IBAction func goToUpperPrimary(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Upper Primary"
        recentlyOpenedDate = newDate
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
            userDefaults.set(primaryLevel, forKey: "Recently Opened Date")
        }
        
        checkRecentlyOpened()
    }
    
    // Segue Config
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectLessonVC = segue.destination as! ChooseTopicViewController
        
        selectLessonVC.primaryLevel = primaryLevel
        selectLessonVC.userPoints = userPoints
        selectLessonVC.userName = storedUserName
    }
}
