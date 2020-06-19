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
    var amtOfPoints:Int = 0
    var primaryLevel:Int = 0
    var numberOfBadges:Int = 0
    
    var storedUserName = ""
    var storedUserAge = ""
    
    let userDefaults = UserDefaults.standard
    
    func passDataBack(settingsUserName: String, settingsUserAge:String) {
        storedUserName = settingsUserName
        storedUserAge = settingsUserAge
    }
    
    // Buttons and Label
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var primaryLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as! SettingsViewController
        
        settingsVC.delegate = self
    }
}
