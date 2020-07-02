//
//  ChooseTopicViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 19/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class ChooseTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedSubtopic:String = ""
    var primaryLevel:String = ""
    var userName = ""
    
    let userDefaults = UserDefaults.standard
    
    // Data Collection Variables
    var lowerUpperPrimary = [""]
    var overallTopics = [""]
    var test = [""]
    
    // UI Elements
    @IBOutlet weak var mainUPLabel: UILabel!
    @IBOutlet weak var secUPLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // Save data into user defaults
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        // Set labels
        mainUPLabel.text = "\(primaryLevel)"
        secUPLabel.text =  "The \(primaryLevel) Syllabus"
        
        // Grab from User Defaults
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
                    
                    
                    
                    lowerUpperPrimary = worksheet.cells(atColumns: [ColumnReference("A")!])
                        .compactMap { $0.stringValue(sharedStrings) }
                    overallTopics = worksheet.cells(atColumns: [ColumnReference("B")!])
                        .compactMap { $0.stringValue(sharedStrings) }
                                        
                    test = worksheet.cells(atRows: [2])
                    .compactMap { $0.stringValue(sharedStrings)}
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    // Set data into Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return overallTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        cell.textLabel!.text = "\(overallTopics[indexPath.row])"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
