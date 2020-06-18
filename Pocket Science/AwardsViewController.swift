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
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if (amountOfBadges != 0) {
            userDefaults.set(amountOfBadges, forKey: "Amount of Badges")
        }
    }

}
