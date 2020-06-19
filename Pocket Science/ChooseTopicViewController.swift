//
//  ChooseTopicViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 19/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class ChooseTopicViewController: UIViewController {
    
    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedSubtopic:String = ""
    var primaryLevel:String = ""
    var userName = ""
    
    let userDefaults = UserDefaults.standard
    
    // UI Elements
    @IBOutlet weak var mainUPLabel: UILabel!
    @IBOutlet weak var secUPLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        mainUPLabel.text = "\(primaryLevel)"
        secUPLabel.text =  "The \(primaryLevel) Syllabus"
        
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
        }
        
        // Get Data from Data File (Data.xlsx)
//        let filepath = "./Data.xlsx"
//        guard let file = XLSXFile(filepath: filepath) else {
//          fatalError("XLSX file at \(filepath) is corrupted or does not exist")
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
