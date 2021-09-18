//
//  SettingsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, dataFromSettings {
    
    // Variables
    var userName:String = ""
    var tierLevel:String = ""
    var userPoints:Int = 0
    var primaryLevel:Int = 0
    var numberOfBadges:Int = 0
    var userRank:String = ""
    var numberOfTopics = 0
    var studiedTopicsArray = [""]
    var numOfStudiedTopics = 0
    
    var storedUserName = ""
    var storedUserAge = ""
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!

    func passDataBack(settingsUserName: String, settingsUserAge:String) {
        storedUserName = settingsUserName
        storedUserAge = settingsUserAge
    }
    
    // Buttons and Label
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var primaryLevelLabel: UILabel!
    @IBOutlet weak var perfomanceBG: UILabel!
    @IBOutlet weak var statusBG: UILabel!
    @IBOutlet weak var uiBG: UILabel!
    
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var userBadgesLabel: UILabel!
    @IBOutlet weak var studiedTopicsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userName = userDefaults.string(forKey: "Username") {
            userNameLabel.text = "\(userName)"
            storedUserName = "\(userName)"
        } else {
            userNameLabel.text = "Hello, User"
            storedUserName = "User"
        }
        if let userAge = userDefaults.string(forKey: "Userage") {
            storedUserAge = userAge
            primaryLevelLabel.text = "\(storedUserAge) Student"
        } else {
            storedUserAge = "NIL"
            primaryLevelLabel.text = "Student"
        }
        
        if let userTier = userDefaults.string(forKey: "User Tier") {
            tierLevel = userTier
        } else {
            tierLevel = "NIL"
        }
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int {
            userPoints = userPointsGrab
        }
        
        if let rank = userDefaults.string(forKey: "User Rank") {
            userRank = rank
        } else {
            userRank = "No Rank"
        }
        
        studiedTopicsArray = userDefaults.object(forKey: "Studied Topics") as? [String] ?? [String]()
        
        studiedTopicsArray = Array(Set(studiedTopicsArray))
        
        numOfStudiedTopics = studiedTopicsArray.count
        if let studiedTopicsArr = userDefaults.object(forKey: "Studied Topics") as? [String]  {
            studiedTopicsArray = studiedTopicsArr

            studiedTopicsArray = Array(Set(studiedTopicsArray))
            
            numOfStudiedTopics = studiedTopicsArray.count
        } else {
            numOfStudiedTopics = 0
        }
                
        if (storedUserAge == "Lower Primary") {
            numberOfTopics = 5
        } else if (storedUserAge == "Upper Primary") {
            numberOfTopics = 4
        } else if (storedUserAge == "Post-Primary") {
            numberOfTopics = 9
        } else {
            numberOfTopics = 0
        }
            
        // Set Clip to Bounds
        perfomanceBG.clipsToBounds = true
        statusBG.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        perfomanceBG.layer.cornerRadius = 15
        statusBG.layer.cornerRadius = 15
        uiBG.layer.cornerRadius = 20
        
        // Label Text
        userRankLabel.text = userRank
        studiedTopicsLabel.text = "\(numOfStudiedTopics)/\(numberOfTopics)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as! SettingsViewController
        
        settingsVC.delegate = self
    }
}
