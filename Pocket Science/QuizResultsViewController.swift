//
//  QuizResultsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 13/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class QuizResultsViewController: UIViewController {

    // Variables
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0
    var userPoints:Int = 0
    var primaryLevel:String = ""
    var userName:String = ""
    var correctAmountOfQuiz = ""
    var correctQnName = [""]
    var incorrectQnName = [""]
    var earnedPoints = 0
    var selectedLesson = ""
    
    let message = ["Good Job!", "Try Again!", "You can do it!", "Almost There!"]
    
    let userDefaults = UserDefaults.standard
    
    // Buttons and Labels
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var reviewAns: UIButton!
    @IBOutlet weak var noRetryBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scoredLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var totalAmtPoints: UILabel!
    @IBOutlet weak var priSchLvl: UILabel!
    
    func pointSystem() {
        let amountOfPointsPerQn = 10
        
        earnedPoints = correctQnName.count * amountOfPointsPerQn
        
        userPoints += earnedPoints
        
        userDefaults.set(userPoints,forKey: "User Points")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let settingsUserName = userDefaults.string(forKey: "Username") {
            userName = settingsUserName
        } else {
            userName = "User"
        }
        
        if let correctQn = userDefaults.object(forKey: "Correct Qns Array") as? [String] ?? [] {
            correctQnName = correctQn
        }
        
        if let incorrectQn = userDefaults.object(forKey: "Incorrect Qns Array") as? [String] ?? [] {
            incorrectQnName = incorrectQn
        }
        
        if let amtOfQns:Int = userDefaults.integer(forKey: "Total amount of Quiz Qns") {
            totalAmtOfQns = amtOfQns
        }
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
        }
        
        if (correctAmountOfQuiz != "") {
            userDefaults.set(correctAmountOfQuiz, forKey: "Correct Quizes")
        }
        // Save User Points
        if userPoints != 0 {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        // Set Buttons and Padding Corner
        uiBG.clipsToBounds = true
        uiBG.layer.cornerRadius = 20
        
        noRetryBtn.clipsToBounds = true
        noRetryBtn.layer.cornerRadius = 20
        
        retryBtn.clipsToBounds = true
        retryBtn.layer.cornerRadius = 20
        
        reviewAns.clipsToBounds = true
        reviewAns.layer.cornerRadius = 20
        
        // Point System
        pointSystem()
        
        // Set Clip
        priSchLvl.numberOfLines = 0; // Dynamic number of lines
        priSchLvl.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        // Set Label Text
        totalAmtPoints.text = "You have \(userPoints) Points now"
        scoredLabel.text = "\(correctQnName.count)/\(totalAmtOfQns)"
        earnedLabel.text = "You earned \(earnedPoints) Points"
        messageLabel.text = "\(message[0]) \(userName)"
        priSchLvl.text = "\(primaryLevel) \(selectedLesson)"
    }
    
    @IBAction func reviewBtn(_ sender: Any) {
        performSegue(withIdentifier: "reviewAns", sender: nil)
    }
}
