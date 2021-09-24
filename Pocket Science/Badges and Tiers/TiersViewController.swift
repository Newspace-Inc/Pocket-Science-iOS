//
//  RedeemItemsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 3/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class TiersViewController: UIViewController {
    
    // Variables/Arrays
    var tierRequirment = [""]
    var awardRequirment = [100, 500, 1000, 5000]
    var awardName = [""]
    var userPoints = 0
    var tierRewards = [""]
    var userTier = ""
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!

    // Labels and Buttons
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bronzeBG: UILabel!
    @IBOutlet weak var silverBG: UILabel!
    @IBOutlet weak var goldBG: UILabel!
    @IBOutlet weak var diamondBG: UILabel!
    @IBOutlet weak var uiBG: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tierLevel = userDefaults.string(forKey: "User Tier") {
            userTier = tierLevel
        } else {
            userTier = "NIL"
        }
        if let rank = userDefaults.string(forKey: "User Tier") {
            userTier = rank
        } else {
            userTier = "NIL"
        }
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int {
            userPoints = userPointsGrab
        }
        
        // Set Clips to Bounds
        pointLabel.clipsToBounds = true
        bronzeBG.clipsToBounds = true
        silverBG.clipsToBounds = true
        goldBG.clipsToBounds = true
        diamondBG.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        pointLabel?.layer.cornerRadius = 10
        bronzeBG?.layer.cornerRadius = 20
        silverBG?.layer.cornerRadius = 20
        goldBG?.layer.cornerRadius = 20
        diamondBG?.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
        // Set User Points
        pointLabel.text = "\(userPoints) Points"
    }
    
}
