//
//  TopicsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class LessonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedLesson:String = ""
    var primaryLevel:String = ""
    var amountOfFinishedLessons = ""
    var quizType = ""
    
    let userDefaults = UserDefaults.standard
            
    // Labels and Buttons
    @IBOutlet weak var primaryLabel1: UILabel!
    @IBOutlet weak var primaryLabel2: UILabel!
    @IBOutlet weak var MCQBtn: UIButton! // Quiz View
    @IBOutlet weak var spellingBtn: UIButton! // Quiz View
    @IBOutlet weak var uiBG: UILabel!
    
    // View Types
    @IBOutlet weak var topicSelectionView: UIView!
    @IBOutlet weak var subtopicTableView: UITableView!
    @IBOutlet weak var quizSelectionView: UIView!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Segmented Control
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    
    // Data Collection Arrays
    var overallTopics = [""]
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Clip to Bounds
        MCQBtn.clipsToBounds = true
        spellingBtn.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        MCQBtn.layer.cornerRadius = 20
        spellingBtn.layer.cornerRadius = 20
        uiBG?.layer.cornerRadius = 20
        
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
        }
        
        // Set labels
        primaryLabel1.text = "\(primaryLevel)"
        primaryLabel2.text =  "Primary School \(selectedLesson)"
        
        topicSelectionView.isHidden = false
        subtopicTableView.isHidden = true
        quizSelectionView.isHidden = true
        
        // Set Delegate and Data Source
        tableView.delegate = self
        tableView.dataSource = self
                
        // Collect Data
        do {
            let filepath = Bundle.main.path(forResource: "Main Data", ofType: "xlsx")!
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                    let sharedStrings = try file.parseSharedStrings()
                    let worksheet = try file.parseWorksheet(at: path)
                    
                    overallTopics = worksheet.cells(atColumns: [ColumnReference("C")!])
                      .compactMap { $0.stringValue(sharedStrings) }
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.layer.cornerRadius = 5

        cell.textLabel!.text = "\(overallTopics[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = FlashcardsViewController()
        
        destinationVC.selectedOverallTopic = overallTopics[indexPath.row]
        
        if overallTopics[indexPath.row] != "" {
            userDefaults.set(overallTopics[indexPath.row], forKey: "Overall Selected Topic")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC1 = segue.destination as! QuizViewController
        
        // Send data to Quiz Controller
        destinationVC1.recentlyOpenedLevel = recentlyOpenedLevel
        destinationVC1.primaryLevel = primaryLevel
        destinationVC1.quizType = quizType
    }
    
    @IBAction func segmentedCtrl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            topicSelectionView.isHidden = false
            subtopicTableView.isHidden = true
            quizSelectionView.isHidden = true
            
            break
        case 1:
            topicSelectionView.isHidden = true
            subtopicTableView.isHidden = false
            quizSelectionView.isHidden = true
            
            break
        case 2:
            topicSelectionView.isHidden = true
            subtopicTableView.isHidden = true
            quizSelectionView.isHidden = false
            
            break
        default:
            break
        }
    }
    @IBAction func MCQBtn(_ sender: Any) {
        performSegue(withIdentifier: "Quiz", sender: nil)
        quizType = "Multiple Choice Questions"
    }
    @IBAction func spellingBtn(_ sender: Any) {
        // Create Alert
        var dialogMessage = UIAlertController(title: "Work In Progress", message: "The spelling test is currently a work in progress. Please check back soon.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // Erase Data code
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // Cancelation code
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
    }
}
