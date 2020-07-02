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
    var userPoints = ""
    var tierRewards = [""]
    var userTier = ""
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bronzeBG: UILabel!
    @IBOutlet weak var silverBG: UILabel!
    @IBOutlet weak var goldBG: UILabel!
    @IBOutlet weak var diamondBG: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if let storedUserPoints = userDefaults.string(forKey: "Userpoints") {
            userPoints = storedUserPoints
            pointLabel.text = "\(storedUserPoints) Points"
        } else {
            userPoints = "0"
            pointLabel.text = "0 Points"
        }
        
        if let tierLevel = userDefaults.string(forKey: "User Tier") {
            userTier = tierLevel
        } else {
            userTier = "NIL"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Corner Radius
        pointLabel.layer.cornerRadius = 10
        bronzeBG.layer.cornerRadius = 20
        silverBG.layer.cornerRadius = 20
        goldBG.layer.cornerRadius = 20
        diamondBG.layer.cornerRadius = 20
        
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
