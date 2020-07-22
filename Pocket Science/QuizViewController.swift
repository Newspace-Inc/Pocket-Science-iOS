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
    var dataPassCheck:Bool = false
    var primaryLevel:String = ""
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0
    var quizType = ""
    var userPoints = 0
    var selectedLesson = ""
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionThreeBtn: UIButton!
    @IBOutlet weak var optionFourBtn: UIButton!
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var primarySchoolLvel: UILabel!
    
    // Views
    @IBOutlet weak var spellingView: UIView!
    @IBOutlet weak var MCQView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        if let selectedQuizType = userDefaults.string(forKey: "Quiz Type") {
            quizType = selectedQuizType
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
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
        primarySchoolLvel.text = "\(primaryLevel) \(selectedLesson)"

        // Change Quiz Type
        if (quizType == "Multiple Choice Questions") {
            spellingView.isHidden = true
            MCQView.isHidden = false
        } else if (quizType == "Spelling") {
            spellingView.isHidden = false
            MCQView.isHidden = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultsViewController
        destinationVC.primaryLevel = primaryLevel
        destinationVC.amtOfCorrectAns = amtOfCorrectAns
        destinationVC.amtOfPointsEarned = amtOfPointsEarned
        destinationVC.totalAmtOfQns = totalAmtOfQns
    }
    
}
