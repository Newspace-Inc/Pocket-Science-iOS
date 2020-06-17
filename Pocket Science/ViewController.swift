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
    var userName:String = ""
    var userAge:Int = 0
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
    
    func passDataBack(settingsUserName: String) {
        userName = settingsUserName
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userName = userDefaults.string(forKey: "User") {
            userNameLabel.text = "\(userName)"
        } else {
            userNameLabel.text = "User"
        }
    }
    
    // Button Config
    @IBAction func goToRecentlyOpened(_ sender: Any) {
        if (recentlyOpenedTopic == "") {
            recentlyOpenedBtn.setTitle("No Recently Opened Topics", for: .normal)
//            recentlyOpenedBtn.backgroundColor =
            lvlLabel.alpha = 0
            topicLabel.alpha = 0
        } else if (recentlyOpenedTopic == "Lower Primary") {
            lvlLabel.textColor = UIColor(displayP3Red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
            topicLabel.textColor = UIColor(displayP3Red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.backgroundColor = UIColor(displayP3Red: 100.0, green: 170.0, blue: 149.0, alpha: 1.0)
            recentlyOpenedBtn.setTitle("", for: .normal)
        } else if (recentlyOpenedTopic == "Upper Primary") {
//            lvlLabel.textColor =
//            topicLabel.textColor =
            lvlLabel.alpha = 1
            topicLabel.alpha = 1
            recentlyOpenedBtn.setTitle("", for: .normal)
        }
    }
    
    @IBAction func goToLowerPrimary(_ sender: Any) {
       let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Lower Primary"
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
    }
    
    @IBAction func goToUpperPrimary(_ sender: Any) {
        let selectLessonVC = ChooseTopicViewController()
        
        primaryLevel = "Upper Primary"
        recentlyOpenedTopic = primaryLevel
        selectLessonVC.primaryLevel = primaryLevel
        performSegue(withIdentifier: "lessons", sender: nil)
    }
    
    // Segue Config
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectLessonVC = segue.destination as! ChooseTopicViewController
        
        selectLessonVC.primaryLevel = primaryLevel
        selectLessonVC.userPoints = userPoints
        selectLessonVC.userName = userName
    }
}

