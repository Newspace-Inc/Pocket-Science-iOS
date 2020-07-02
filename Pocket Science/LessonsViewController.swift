//
//  TopicsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class LessonsViewController: UIViewController {

    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedLesson:String = ""
    var primaryLevel:String = ""
    var amountOfFinishedLessons = ""
    
    let userDefaults = UserDefaults.standard
            
    // Labels and Buttons
    @IBOutlet weak var primaryLabel1: UILabel!
    @IBOutlet weak var primaryLabel2: UILabel!
    
    // Segmented Control
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        // Set labels
        primaryLabel1.text = "\(primaryLevel)"
        primaryLabel2.text =  "The \(primaryLevel) Syllabus"
        
        // Collect Data
        do {
            let filepath = Bundle.main.path(forResource: "data", ofType: "xlsx")!
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                    if let worksheetName = name {
                        print("This worksheet has a name: \(worksheetName)")
                    }
                    let sharedStrings = try file.parseSharedStrings()
                    let worksheet = try file.parseWorksheet(at: path)
                    
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC1 = segue.destination as! QuizViewController
        
        // Send data to Quiz Controller
        destinationVC1.recentlyOpenedLevel = recentlyOpenedLevel
        destinationVC1.primaryLevel = primaryLevel
    }
    
    @IBAction func segmentedCtrl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: break
            
        case 1: break
            
        case 2: break
            
        default:
            break
        }
    }
    
    // Create Topic Explaination UI
    
    // Create Subtopic UI
    
    // Create Quiz UI
}
