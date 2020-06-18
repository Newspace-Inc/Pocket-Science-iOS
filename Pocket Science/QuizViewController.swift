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
    
    let userDefaults = UserDefaults.standard

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (storedUserPoints != 0) {
            userDefaults.set(storedUserPoints, forKey: "Userpoints")
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
