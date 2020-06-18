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
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        if let storedUserPoints = userDefaults.string(forKey: "Userpoints") {
            userPoints = storedUserPoints
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
