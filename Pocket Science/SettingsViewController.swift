//
//  SettingsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 16/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit


protocol dataFromSettings {
    func passDataBack(settingsUserName: String)
}

class SettingsViewController: UIViewController {

    // Variables
    var settingsUserName:String = ""
    var primaryLevel:String = ""
    var settingsUserAge:Int = 0
    var delegate:dataFromSettings!
    let userDefaults = UserDefaults.standard
    
    // Text Fields
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    // Buttons/Labels
    @IBOutlet weak var saveEditBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveEditBtn(_ sender: Any) {
        let mainVC = ViewController()
        let settingsVC = SettingsViewController()
        var conversion:String = ""
        
        conversion = ageTF.text ?? ""
        
        let userName = (nameTF.text ?? "").isEmpty ? "" : nameTF.text
        settingsUserAge = (Int(conversion) ?? settingsUserAge)
        
        if userName != "" {
            userDefaults.set(userName, forKey: "User")
        }
        
        settingsUserName = userName ?? ""
        
        settingsVC.settingsUserName = settingsUserName
        mainVC.userName = settingsUserName
        
        // User Name
        if (settingsUserName == "") {
            nameLabel.text = "Name: NIL"
        } else {
        nameLabel.text = "Name: \(settingsUserName)"
        }
        
        statusLabel.text = "Saved Successfully."
        statusLabel.alpha = 1
        
        delegate.passDataBack(settingsUserName: settingsUserName)
    }
    
    @IBAction func DismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
