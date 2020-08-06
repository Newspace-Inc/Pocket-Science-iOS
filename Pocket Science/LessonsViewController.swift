//
//  TopicsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

extension Array where Element: Equatable {
    func remove(_ obj: Element) -> [Element] {
        return filter { $0 != obj }
    }
}

class LessonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedLesson:String = ""
    var primaryLevel:String = ""
    var amountOfFinishedLessons = ""
    var quizType = ""
    var worksheetName = ""
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var primaryLabel1: UILabel!
    @IBOutlet weak var primaryLabel2: UILabel!
    @IBOutlet weak var MCQBtn: UIButton! // Quiz View
    @IBOutlet weak var spellingBtn: UIButton! // Quiz View
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var ExplainationImgView: UIImageView!
    @IBOutlet weak var ExplainationTextField: UITextView!
    
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
    var userSelectedTopic = [""]
    
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
        worksheetName = "\(primaryLevel) Data"
        
        do {
            let filepath = Bundle.main.path(forResource: "Main Data", ofType: "xlsx")!
            
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                guard let path = try file.parseWorksheetPathsAndNames(workbook: wbk)
                        .first(where: { $0.name == worksheetName }).map({ $0.path })
                else { continue }
                
                let sharedStrings = try file.parseSharedStrings()
                let worksheet = try file.parseWorksheet(at: path)
                
                var endTopicSel = 0
                var startTopicSel = 0
                
                // Get Cell Data
                let topic = worksheet.cells(atColumns: [ColumnReference("B")!])
                    .compactMap{ $0.stringValue(sharedStrings) }
                
                overallTopics = worksheet.cells(atColumns: [ColumnReference("C")!])
                    .compactMap { $0.stringValue(sharedStrings) }
                                
                // Find Rows of Selected Topic
                let findTopicSelectedStart = topic.firstIndex(of: selectedLesson)
                if findTopicSelectedStart != nil {
                    startTopicSel = Int(findTopicSelectedStart ?? 0) + 1
                }
                
                let findTopicSelectedEnd = topic.lastIndex(of: selectedLesson)
                if findTopicSelectedEnd != nil {
                    endTopicSel = Int(findTopicSelectedEnd ?? 0) + 1
                }
                                
                for i in startTopicSel...endTopicSel - 1 {
                    userSelectedTopic.append(overallTopics[i])
                }
                
                userSelectedTopic = Array(Set(userSelectedTopic))
                userSelectedTopic = userSelectedTopic.remove("")
                
                userDefaults.set(startTopicSel, forKey: "TopicSelStart")
                userDefaults.set(endTopicSel, forKey: "TopicSelEnd")
                
                var topicExplaination = worksheet.cells(atRows: [UInt(startTopicSel)])
                    .compactMap { $0.stringValue(sharedStrings) }
                                
                if (topicExplaination[2] == topicExplaination[3]) {
                    topicExplaination.removeSubrange(0..<4)
                    
                    topicExplaination = topicExplaination.remove("Empty Cell")
                    
                    let explaination = topicExplaination.joined(separator: "\n")
                    
                    ExplainationTextField.text = "\(explaination)"
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSelectedTopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.layer.cornerRadius = 5
        
        cell.textLabel!.text = "\(userSelectedTopic[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = FlashcardsViewController()
        
        destinationVC.selectedOverallTopic = userSelectedTopic[indexPath.row]
        
        if overallTopics[indexPath.row] != "" {
            userDefaults.set(userSelectedTopic[indexPath.row], forKey: "Overall Selected Topic")
        }
        performSegue(withIdentifier: "flashcards", sender: nil)
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
        quizType = "Multiple Choice Questions"
        userDefaults.set(quizType, forKey: "Quiz Type")
                
        performSegue(withIdentifier: "Quiz", sender: nil)
    }
    @IBAction func spellingBtn(_ sender: Any) {
        // Create Alert
        let dialogMessage = UIAlertController(title: "Work In Progress", message: "The spelling test is currently a work in progress. Please check back soon.", preferredStyle: .alert)
        
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
