//
//  AwardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class AwardsViewController: UIViewController {

    
    let userDefaults = UserDefaults.standard
    
    // Variables/Arrays
    var tierLevel = [""]
    var tierPoints = [0]
    var tierRewards = [""]
    var amountOfBadges = 0
    var userRank = ""
    
    // UI Elements
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if (amountOfBadges != 0) {
            userDefaults.set(amountOfBadges, forKey: "Amount of Badges")
        }
        
        if (userRank != "") {
            userDefaults.set(userRank, forKey: "User Rank")
        }
        
        if let rank = userDefaults.string(forKey: "User Rank") {
            userRank = rank
        } else {
            userRank = "NIL"
        }
        
        // Rank Label
        userRankLabel.text = "Current Rank: \(userRank)"
        
        // Set Corner Radius
        badgesLabel.layer.cornerRadius = 30
        rankLabel.layer.cornerRadius = 30
        userRankLabel.layer.cornerRadius = 20
    }

}
