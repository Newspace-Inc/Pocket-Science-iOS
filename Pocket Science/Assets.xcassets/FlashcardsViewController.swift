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
    @IBOutlet weak var uiBG: UILabel!
    
    // Variables
    var favouriteFlashcard = [""]
    var selectedOverallTopic = ""
    var selectedConcept = ""
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Clip to Bounds
        imageView.clipsToBounds = true
        bgPadding.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Curved Corners
        imageView.layer.cornerRadius = 20
        bgPadding.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let favouriteFlashcardArray = userDefaults.string(forKey: "") {
            
        }
        if let selectedOverall = userDefaults.string(forKey: "Selected Overall Topics") {
            selectedOverallTopic = selectedOverall
            
        }
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {
        
        for i in 0...favouriteFlashcard.count {
            if (favouriteFlashcard[i] == selectedConcept) {
                favouriteButton.setImage(UIImage(named: "heart.fill"), for: .normal)
                favouriteFlashcard.append(selectedConcept)
            } else {
                favouriteButton.setImage(UIImage(named: "heart"), for: .normal)
            }
        }
        
        if (favouriteFlashcard != [""]) {
            userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
        }
    }
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if swipeGesture.direction == .left {
            
        } else if (swipeGesture.direction == .right) {
            
        }
    }
}
