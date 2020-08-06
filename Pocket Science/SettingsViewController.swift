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
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var creditsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Corner Radius
        saveEditBtn.layer.cornerRadius = 20
        eraseData.layer.cornerRadius = 20
    }
    
    func deleteDataAlert() {
        let intReset = 0
        let strReset = ""
        let arrReset = [""]
        // Create Alert
        var dialogMessage = UIAlertController(title: "Delete Data", message: "Are you sure you want to erase your data? This action is NOT REVERSABLE.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
            self.userDefaults.set(strReset,forKey: "Selected Favourite Flashcard")
            self.userDefaults.set(arrReset, forKey: "Favourite Flashcards")
            self.userDefaults.set(strReset, forKey: "Username")
            self.userDefaults.set(intReset, forKey: "Userage")
            self.userDefaults.set(strReset, forKey: "Overall Selected Topics")
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // Cancelation code
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func saveEditBtn(_ sender: Any) {
        let mainVC = ViewController()
        let settingsVC = SettingsViewController()
        
        var userAge = (ageTF.text ?? "").isEmpty ? "" : ageTF.text
        let userName = (nameTF.text ?? "").isEmpty ? "" : nameTF.text
        
//        let intUserAge:Int = Int(userAge) ?? 0
        
        settingsUserAge = userAge ?? ""
        settingsUserName = userName ?? ""
        
        let conversionAge = Int(userAge ?? "") ?? 0
        
        if (conversionAge < 7) {
            userAge = "Pre-Primary"
        } else if (conversionAge >= 7 && conversionAge <= 9) {
            userAge = "Lower Primary"
        } else if (conversionAge >= 10 && conversionAge <= 12) {
            userAge = "Upper Primary"
        } else {
            userAge = "Post-Primary"
        }
        
        if userName != "" {
            userDefaults.set(userName, forKey: "Username")
        }
        if userAge != "" {
            userDefaults.set(userAge, forKey: "Userage")
        }
        
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
        deleteDataAlert()
        statusLabel.alpha = 0
    }
    @IBAction func tutorialBtn(_ sender: Any) {
        performSegue(withIdentifier: "tutorial", sender: nil)
    }
    @IBAction func creditsBtn(_ sender: Any) {
        performSegue(withIdentifier: "credits", sender: nil)
    }
}
