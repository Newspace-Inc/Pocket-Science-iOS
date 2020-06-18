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
    var selectedTopic:String = ""
    var primaryLevel:String = ""
            
    // Labels and Buttons
    
    // Segmented Control
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        // Data collection
        do {
            guard let file = XLSXFile(filepath: "./Data.xlsx") else {
              fatalError("XLSX file corrupted or does not exist")
            }

            for path in try file.parseWorksheetPaths() {
                let worksheet = try file.parseWorksheet(at: path)
                let sharedStrings = try file.parseSharedStrings()
                let columnCStrings = worksheet.cells(atColumns: [ColumnReference("C")!])
                .compactMap { $0.stringValue(sharedStrings) }
                
                print(columnCStrings)
            }
        } catch {
            fatalError("An error occured. \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC1 = segue.destination as! QuizViewController
        
        // Send data to Quiz Controller
        destinationVC1.recentlyOpenedLevel = recentlyOpenedLevel
        destinationVC1.primaryLevel = primaryLevel
    }
    
    @IBAction func segmentedCtrl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) { // User selected topic explaination
            
        } else if (sender.selectedSegmentIndex == 1) { // User selected subtopics
            
        } else { // User Selected Quiz
            
        }
    }
    
    // Create Topic Explaination UI
    
    // Create Subtopic UI
    
    // Create Quiz UI
}
