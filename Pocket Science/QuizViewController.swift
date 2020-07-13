//
//  QuizViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 13/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // Variales
    var recentlyOpenedLevel:String = ""
    var storedUserPoints:Int = 0
    var dataPassCheck:Bool = false
    var primaryLevel:String = ""
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0
    var quizType = ""
    
    let userDefaults = UserDefaults.standard

    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionThreeBtn: UIButton!
    @IBOutlet weak var optionFourBtn: UIButton!
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var primarySchoolLvel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (storedUserPoints != 0) {
            userDefaults.set(storedUserPoints, forKey: "Userpoints")
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        optionOneBtn.clipsToBounds = true
        optionTwoBtn.clipsToBounds = true
        optionThreeBtn.clipsToBounds = true
        optionFourBtn.clipsToBounds = true
        
        // Set Corner Radius
        uiBG?.layer.cornerRadius = 20
        optionOneBtn.layer.cornerRadius = 20
        optionTwoBtn.layer.cornerRadius = 20
        optionThreeBtn.layer.cornerRadius = 20
        optionFourBtn.layer.cornerRadius = 20
        
        // Set Label Names
        quizTypeLabel.text = quizType
        primarySchoolLvel.text = primaryLevel
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultsViewController
        destinationVC.primaryLevel = primaryLevel
        destinationVC.amtOfCorrectAns = amtOfCorrectAns
        destinationVC.amtOfPointsEarned = amtOfPointsEarned
        destinationVC.totalAmtOfQns = totalAmtOfQns
    }

}
