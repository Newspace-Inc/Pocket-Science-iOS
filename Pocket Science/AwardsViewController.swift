//
//  AwardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class AwardsViewController: UIViewController {

    // Get Data File
    let dataFile = data()
    
    // Variables/Arrays
    var tierLevel = [""]
    var tierPoints = [0]
    var tierRewards = [""]
    var amountOfBadges = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tierLevel = dataFile.tierLevel
        tierPoints = dataFile.tierPoints
        tierRewards = dataFile.tierRewards
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
