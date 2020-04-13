//
//  data.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import Foundation

class data {
    var userPoints: Int?
    
    struct userRanks {
        let userRankNames = [""]
        let userRankPointsRequirment = [""]
    }
    
    struct lowerPrimaryData {
        let topics = ["Diversity, Cycles, Systems, Interactions, Energy"]
        let diversityData = [""]
        let cycleData = [""]
        let systemData = [""]
        let interactionData = [""]
        let energyData = [""]
    }
    
    struct upperPrimaryData {
        let topics = ["Cycles, Systems, Interactions, Energy"]
        let cycleData = [""]
        let systemData = [""]
        let interactionData = [""]
        let energyData = [""]
    }
    
    struct redeemableItems {
        let items = [""]
    }
    
    struct points {
        let pointsPerQuestion:Int = 0
        var dailyLogInPoints:Int = 0
        var userPointData:Int = 0
    }
}
