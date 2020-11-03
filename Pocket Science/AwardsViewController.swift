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
    var earnedAwards = [""]
    var quizAttempts = 0
    var notEarnedImage = ["Beginner_Not_Earned", "Bookworm_Not_Earned","Brainy_Not_Earned", "Diligent_Ant_Not_Earned","Expert_Not_Earned", "Industrious_Bee_Not_Earned","Maestro_Not_Earned","Normal member_Not_Earned","Perfectionist_Not_Earned","Quintessential_Not_Earned","Regular member_Not_Earned","Star collector_Not_Earned", "Streaker_Bronze_Not_Earned", "Streaker_Gold_Not_Earned","Streaker_Silver_Not_Earned"]
    var earnedImage = ["Beginner Badge", "Bookworm Badge", "Brainy Badge", "Diligent Ant Badge", "Expert Badge", "Frequent Member Badge", "Industrious Bee Badge", "Maestro Badge", "Normal Member Badge", "Perfectionist Badge", "Regular Member Badge","Star Collector Badge","Streaker Bronze Badge","Streaker Gold Badge", "Streaker Silver Badge"]
    
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
        
        if let attemptCount:Int = userDefaults.integer(forKey: "Quiz Attempts") {
            quizAttempts = attemptCount
        }
        
        if (userTier != "") {
            userDefaults.set(userTier, forKey: "User Tier")
        }
        
        if (userPoints != 0) {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        if let earned = userDefaults.object(forKey: "Earned Awards") {
            earnedAwards = earned as! [String]
        }
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        if let rank = userDefaults.string(forKey: "User Tier") {
            userTier = rank
        } else {
            userTier = "NIL"
        }
        
        // Set Clip to Bounds
        badgesLabel.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        badgesLabel.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
        // Set Scroll View
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 671)
        
        // Check User Awards
        if (earnedAwards.count == 1) {
            beginnerImage.image = UIImage(named: earnedImage[0])
            bookworkImage.image = UIImage(named: notEarnedImage[1])
            diligentAntImage.image = UIImage(named: notEarnedImage[3])
            expertImage.image = UIImage(named: notEarnedImage[4])
            frequentMemberImage.image = UIImage(named: notEarnedImage[5])
            industriousBeeImage.image = UIImage(named: notEarnedImage[6])
            masteroImage.image = UIImage(named: notEarnedImage[7])
            normalMemberImage.image = UIImage(named: notEarnedImage[8])
            regularMemberImage.image = UIImage(named: notEarnedImage[10])
            streakerBronzeImage.image = UIImage(named: notEarnedImage[11])
            streakerGoldImage.image = UIImage(named: notEarnedImage[12])
            streakerSilverImage.image = UIImage(named: notEarnedImage[1])
        } else {
            for i in 0...earnedImage.count - 1 {
                for j in 0...earnedAwards.count - 1 {
                    print("\(earnedImage[i]) and \(earnedAwards[j])")
                    if (earnedImage[i] == earnedAwards[j]) {
                        switch earnedAwards[j] {
                        case "Beginner Badge":
                            beginnerImage.image = UIImage(named: earnedImage[j])
                        case "Bookworm Badge":
                            bookworkImage.image = UIImage(named: earnedImage[j])
                        case "Diligent Ant Badge":
                            diligentAntImage.image = UIImage(named: earnedImage[j])
                        case "Expert Badge":
                            expertImage.image = UIImage(named: earnedImage[j])
                        case "Frequent Member Badge":
                            frequentMemberImage.image = UIImage(named: earnedImage[j])
                        case "Industrious Bee Badge":
                            industriousBeeImage.image = UIImage(named: earnedImage[j])
                        case "Normal Member Badge":
                            normalMemberImage.image = UIImage(named: earnedImage[j])
                        case "Regular Member Badge":
                            regularMemberImage.image = UIImage(named: earnedImage[j])
                        case "Streaker Bronze Badge":
                            streakerBronzeImage.image = UIImage(named: earnedImage[j])
                        case "Streaker Gold Badge":
                            streakerGoldImage.image = UIImage(named: earnedImage[j])
                        case "Streaker Silver Badge":
                            streakerSilverImage.image = UIImage(named: earnedImage[j])
                        default:
                            if (earnedAwards[j] != "Beginner Badge") {
                                beginnerImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Bookworm Badge") {
                                bookworkImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Diligent Ant Badge") {
                                diligentAntImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Expert Badge") {
                                expertImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Frequent Member Badge") {
                                frequentMemberImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Industrious Bee Badge") {
                                industriousBeeImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Normal Member Badge") {
                                normalMemberImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Regular Member Badge") {
                                regularMemberImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Streaker Gold Badge") {
                                streakerGoldImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Streaker Bronze Badge") {
                                streakerBronzeImage.image = UIImage(named: notEarnedImage[j])
                            } else if (earnedAwards[j] != "Streaker Silver Badge") {
                                streakerSilverImage.image = UIImage(named: notEarnedImage[j])
                            }
                        }
                    }
                }
            }
        }
    }
}
