//
//  FlashcardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 22/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class FlashcardsViewController: UIViewController {
    
    // UI Elements
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var conceptNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var bgPadding: UILabel!
    
    // Variables
    let userDefaults = UserDefaults.standard
    var favouriteFlashcard = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Curved Corners
        imageView.layer.cornerRadius = 20
        bgPadding.layer.cornerRadius = 20
        
    }
    @IBAction func favouriteBtn(_ sender: Any) {
        favouriteButton.setImage(UIImage(named: "heart.fill"), for: .normal)
    }
}
