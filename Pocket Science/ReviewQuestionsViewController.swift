//
//  ReviewQuestionsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/8/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class ReviewQuestionsViewController: UIViewController {

    // Variables
    var userName = ""
    var correctQnName = [""]
    var incorrectQnName = [""]
    var totalAmtOfQns:Int = 0
    var userPoints:Int = 0
    var primaryLevel = ""
    var selectedLesson = ""
    
    
    let userDefaults = UserDefaults.standard
    
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
        
        // Save User Points
        if userPoints != 0 {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
