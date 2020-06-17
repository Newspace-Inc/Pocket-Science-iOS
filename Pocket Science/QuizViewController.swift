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
    var userPoints:Int = 0
    var dataPassCheck:Bool = false
    var primaryLevel:String = ""
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultsViewController
        destinationVC.userPoints = userPoints
        destinationVC.primaryLevel = primaryLevel
        destinationVC.amtOfCorrectAns = amtOfCorrectAns
        destinationVC.amtOfPointsEarned = amtOfPointsEarned
        destinationVC.totalAmtOfQns = totalAmtOfQns
    }

}
