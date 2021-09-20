//
//  CheckBadges.swift
//  Pocket Science
//
//  Created by Ethan Chew on 20/9/21.
//  Copyright © 2021 Ethan Chew. All rights reserved.
//

import Foundation

func checkBadges() -> (didNewBadges: Bool, newBadges: [String]) {
    // Variables
    var didNewBadges:Bool = false
    var newBadges:[String] = []
    var earnedAwards:[String] = []
    var badgeNames = ["Beginner Badge", "Bookworm Badge", "Brainy Badge", "Diligent Ant Badge", "Expert Badge", "Frequent Member Badge", "Industrious Bee Badge", "Maestro Badge", "Normal Member Badge", "Perfectionist Badge", "Regular Member Badge","Star Collector Badge","Streaker Bronze Badge","Streaker Gold Badge", "Streaker Silver Badge"]

    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    
    // Get User Defaults
    if let userBadges = userDefaults.object(forKey: "Earned Awards") as? Array<String> {
        earnedAwards = userBadges
    } else {
        return (false, ["Error"])
    }
    
    // Checking
    
    
    earnedAwards.append(contentsOf: newBadges)
    userDefaults.set(earnedAwards, forKey: "Earned Awards")
    return (didNewBadges, newBadges)
}
