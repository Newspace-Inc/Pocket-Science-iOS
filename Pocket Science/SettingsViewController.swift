//
//  SettingsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 16/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit


protocol dataFromSettings {
    func passDataBack(settingsUserName: String, settingsUserAge: String)
}

class SettingsViewController: UIViewController {

    // Variables
    var settingsUserName:String = ""
    var primaryLevel:String = ""
    var settingsUserAge = ""
    var delegate:dataFromSettings!
    let userDefaults = UserDefaults.standard
    
    // Text Fields
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    // Buttons/Labels
    @IBOutlet weak var saveEditBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var eraseData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveEditBtn.layer.cornerRadius = 20
        eraseData.layer.cornerRadius = 20
    }
    
    @IBAction func saveEditBtn(_ sender: Any) {
        let mainVC = ViewController()
        let settingsVC = SettingsViewController()
        
        let userAge = (ageTF.text ?? "").isEmpty ? "" : ageTF.text
        let userName = (nameTF.text ?? "").isEmpty ? "" : nameTF.text
        
        if userName != "" {
            userDefaults.set(userName, forKey: "Username")
        }
        if userAge != "" {
            userDefaults.set(userName, forKey: "Userage")
        }
        
        settingsUserAge = userAge ?? ""
        settingsUserName = userName ?? ""
        
        statusLabel.text = "Saved Successfully."
        statusLabel.alpha = 1
        
        settingsVC.settingsUserName = settingsUserName
        mainVC.storedUserName = settingsUserName
        
        delegate.passDataBack(settingsUserName: settingsUserName, settingsUserAge: settingsUserAge)
    }
    
    @IBAction func DismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func eraseDataBtn(_ sender: Any) {
        // Create Alert
        var dialogMessage = UIAlertController(title: "Delete Data", message: "Are you sure you want to erase your data? This action is NOT REVERSABLE.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // Erase Data code
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // Cancelation code
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
