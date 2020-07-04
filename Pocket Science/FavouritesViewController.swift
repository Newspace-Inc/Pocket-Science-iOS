//
//  FavouritesViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    // Variables
    
    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        uiBG.layer.cornerRadius = 20
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
