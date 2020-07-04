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
    var tierRequirment = [100, 500, 1000, 5000]
    var awardRequirment = [""]
    var awardName = [""]
    var userPoints = ""
    var tierRewards = [""]
    var userTier = ""
    var userAwards = [""]
    
    // UI Elements
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var uiBG: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Int(userPoints) == tierRequirment[0]) {
            userTier = "Bronze"
        } else if (Int(userPoints) == tierRequirment[1]) {
            userTier = "Silver"
        } else if (Int(userPoints) == tierRequirment[2]) {
            userTier = "Gold"
        } else if (Int(userPoints) == tierRequirment[3]) {
            userTier = "Diamond"
        }
        
        if (userTier != "") {
            userDefaults.set(userTier, forKey: "User Tier")
        }
        
        if (userPoints != "") {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        // Rank Label
        userRankLabel.text = "Current Rank: \(userTier)"
        
        // Set Clip to Bounds
        badgesLabel.clipsToBounds = true
        rankLabel.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        badgesLabel.layer.cornerRadius = 30
        rankLabel.layer.cornerRadius = 30
        userRankLabel.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
      if let rank = userDefaults.string(forKey: "User Tier") {
            userTier = rank
        } else {
            userTier = "NIL"
        }
    }
}
