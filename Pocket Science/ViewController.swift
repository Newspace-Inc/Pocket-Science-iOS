//
//  ViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 31/3/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class ViewController: UIViewController, dataFromSettings {
    // Call Data Collection file
    let data = dataCollection()
    let lessonVC = LessonsViewController()
    
    // Variables
    var recentlyOpenedTopic:String = LessonsViewController().recentlyOpenedLevel
    var userPoints:Int = 0
    var primaryLevel:String = LessonsViewController().primaryLevel
    var storedUserName:String = ""
    var storedUserAge = ""
    var userSchool:String = ""
    let userDefaults = UserDefaults.standard
    
    // Buttons and Labels
    @IBOutlet weak var recentlyOpenedBtn: UIButton!
    @IBOutlet weak var upperPrimaryBtn: UIButton!
    @IBOutlet weak var lowerPrimaryBtn: UIButton!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // Background Padding
    @IBOutlet weak var bgPad: UILabel!
    
    func passDataBack(settingsUserName: String, settingsUserAge: String) {
        storedUserName = settingsUserName
        storedUserAge = settingsUserAge
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        if (recentlyOpenedTopic == "Lower Primary") {
            lvlLabel.textColor = UIColor.white
            topicLabel.textColor = UIColor.white
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "5 Chapters"
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = UIColor(red: 50.0/255.0, green: 170.0/255.0, blue: 149.0/255.0, alpha: 1.0)
            recentlyOpenedBtn.setTitle("", for: .normal)
        } else if (recentlyOpenedTopic == "Upper Primary") {
            lvlLabel.text = "\(recentlyOpenedTopic)"
            topicLabel.text = "4 Chapters"
            lvlLabel.textColor = UIColor.gray
            topicLabel.textColor = UIColor.gray
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = UIColor(red: 243.0/255.0, green: 223.0/255.0, blue: 162.0/255.0, alpha: 1.0)
            recentlyOpenedBtn.setTitle("", for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Curved Edges
        recentlyOpenedBtn.layer.cornerRadius = 20
        upperPrimaryBtn.layer.cornerRadius = 20
        lowerPrimaryBtn.layer.cornerRadius = 20
        bgPad.layer.cornerRadius = 30
        
        // Shadows
                
        // Change Label Text to Data
        pointLabel.text = "\(userPoints) Points"
        print("\(recentlyOpenedTopic)")
    }
    
    // Button Config
    @IBAction func goToRecentlyOpened(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
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
