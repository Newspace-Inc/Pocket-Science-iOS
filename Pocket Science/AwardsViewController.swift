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
    var awardName = ["Beginner", "Expert"]
    var userPoints = 0
    var tierRewards = [""]
    var userTier = ""
    var userAwards = [""]
    
    // UI Elements
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Award Image Views
    @IBOutlet weak var beginnerImage: UIImageView!
    @IBOutlet weak var expertImage: UIImageView!
    @IBOutlet weak var masteroImage: UIImageView!
    @IBOutlet weak var streakerBronzeImage: UIImageView!
    @IBOutlet weak var streakerSilverImage: UIImageView!
    @IBOutlet weak var streakerGoldImage: UIImageView!
    @IBOutlet weak var bookworkImage: UIImageView!
    @IBOutlet weak var diligentAntImage: UIImageView!
    @IBOutlet weak var industriousBeeImage: UIImageView!
    @IBOutlet weak var normalMemberImage: UIImageView!
    @IBOutlet weak var regularMemberImage: UIImageView!
    @IBOutlet weak var frequentMemberImage: UIImageView!
    
    
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
        
        if (userPoints != 0) {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        // Set Clip to Bounds
        badgesLabel.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        badgesLabel.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 671)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        if let rank = userDefaults.string(forKey: "User Tier") {
              userTier = rank
          } else {
              userTier = "NIL"
          }
    }
}
