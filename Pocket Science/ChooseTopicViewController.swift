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
    @IBOutlet weak var tableView: UITableView!
    
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
                
                let lowerUpperPrimary = worksheet.cells(atColumns: [ColumnReference("A")!])
                .compactMap { $0.stringValue(sharedStrings) }
                
                let test = worksheet.cells(atRows: [])
                print(lowerUpperPrimary)
              }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
