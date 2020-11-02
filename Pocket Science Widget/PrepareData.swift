//
//  PrepareData.swift
//  Pocket Science
//
//  Created by Ethan Chew on 2/11/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import Foundation

func prepareData() -> (numOfTimesAppWasOpened: Int, earnedAwards: [String], earnedImage: [String], lastOpenedDate: String, lastOpened: String) {
    let userDefaults = UserDefaults.standard
    var numOfTimesAppWasOpened = 0
    var earnedAwards:[String] = []
    let earnedImage = ["Beginner Badge", "Bookworm Badge", "Brainy Badge", "Diligent Ant Badge", "Expert Badge", "Frequent Member Badge", "Industrious Bee Badge", "Maestro Badge", "Normal Member Badge", "Perfectionist Badge", "Regular Member Badge","Star Collector Badge","Streaker Bronze Badge","Streaker Gold Badge", "Streaker Silver Badge"]
    var lastOpenedDate = ""
    var lastOpened = ""
    
    if let userBadges = userDefaults.object(forKey: "Earned Awards") as? Array<String> {
        earnedAwards = userBadges
    }
    
    if let numOfTimes:Int = userDefaults.integer(forKey: "Number Of Times App Opened") {
        numOfTimesAppWasOpened = numOfTimes
    }
    
    if let recentlyOpenedDate = userDefaults.string(forKey: "Recently Opened Date") {
        lastOpenedDate = recentlyOpenedDate
    }
    
    if let primaryLevel = userDefaults.string(forKey: "Recently Opened") {
        lastOpened = primaryLevel
    }
    
    print(lastOpened)
    
    return (numOfTimesAppWasOpened, earnedAwards, earnedImage, lastOpenedDate, lastOpened)
}


