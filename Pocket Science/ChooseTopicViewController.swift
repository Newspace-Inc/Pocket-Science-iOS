//
//  ChooseTopicViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 19/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit

class ChooseTopicViewController: UIViewController {
    
    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedSubtopic:String = ""
    var primaryLevel:String = ""
    var userName = ""
    
    // UI Elements
    @IBOutlet weak var mainUPLabel: UILabel!
    @IBOutlet weak var secUPLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainUPLabel.text = "\(primaryLevel)"
        secUPLabel.text = "The \(primaryLevel) Syllabus"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
