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
    @IBOutlet weak var bgPadding: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Curved Corners
        imageView.layer.cornerRadius = 20
        bgPadding.layer.cornerRadius = 20
        
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
