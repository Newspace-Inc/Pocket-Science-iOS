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
    
    let userDefaults = UserDefaults.standard
    
    // Buttons and Labels
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var noRetryBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let settingsUserName = userDefaults.string(forKey: "Username") {
            userName = settingsUserName
        } else {
            userName = "User"
        }
        
        if let correctQuizes = userDefaults.string(forKey: "Correct Quizes") {
            correctAmountOfQuiz = correctQuizes
        } else {
            correctAmountOfQuiz = "0"
        }
        
        // Set Buttons and Padding Corner
        uiBG.clipsToBounds = true
        uiBG.layer.cornerRadius = 20
        
        noRetryBtn.clipsToBounds = true
        noRetryBtn.layer.cornerRadius = 20
        
        retryBtn.clipsToBounds = true
        retryBtn.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (correctAmountOfQuiz != "") {
            userDefaults.set(correctAmountOfQuiz, forKey: "Correct Quizes")
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
