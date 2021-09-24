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
    var worksheetName = ""
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!

    // Labels and Buttons
    @IBOutlet weak var primaryLabel1: UILabel!
    @IBOutlet weak var primaryLabel2: UILabel!
    @IBOutlet weak var MCQBtn: UIButton! // Quiz View
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
    
    func getData() {
        
        
        
        
        
        
        // Collect Data
        var worksheetName = ""
        worksheetName = "\(primaryLevel) Data"
        
        do {
            let filepath = Bundle.main.path(forResource: "Topic Explaination", ofType: "xlsx")!
            
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                guard let path = try file.parseWorksheetPathsAndNames(workbook: wbk)
                        .first(where: { $0.name == worksheetName }).map({ $0.path })
                else { continue }
                
                let sharedStrings = try file.parseSharedStrings()
                let worksheet = try file.parseWorksheet(at: path)
                
                // Get Cell Data
                let lessons = worksheet.cells(atColumns: [ColumnReference("A")!])
                    .compactMap { $0.stringValue(sharedStrings) }
                
                let index = lessons.firstIndex(of: selectedLesson)! + 1
                
                // Get Data
                var data = worksheet.cells(atRows: [UInt(index)])
                    .compactMap { $0.stringValue(sharedStrings) }
                
                data.remove(at: 0)
                
                let topicImg = data[3]
                data = data.remove(topicImg)

                data = data.remove("Empty Cell")
                data = data.remove("Enpty Cell")
                
                ExplainationTextField.text = data.joined(separator: "\n")
                ExplainationImgView.image = UIImage(named: topicImg + ".img")
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func getMainData() {
        
        var nsDictionary: [String:NSDictionary]
        let path = Bundle.main.path(forResource: "Main Data", ofType: "plist")
        nsDictionary = NSDictionary(contentsOfFile: path!) as! [String : NSDictionary]
        userDefaults.set(selectedLesson,forKey: "selectedLesson")
        let prilevel:[String:NSDictionary]=nsDictionary[primaryLevel] as! [String : NSDictionary]
        userSelectedTopic=prilevel[selectedLesson]?.allKeys as! [String]
        
        
    }
    
    func confirmQuiz() {
        // Collect Data
        let worksheetName = "\(primaryLevel) Data"
        
        do {
            let filepath = Bundle.main.path(forResource: "Questions and Answers", ofType: "xlsx")!
            
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                guard let path = try file.parseWorksheetPathsAndNames(workbook: wbk)
                        .first(where: { $0.name == worksheetName }).map({ $0.path })
                else {
                    continue
                }
                
                let sharedStrings = try file.parseSharedStrings()
                let worksheet = try file.parseWorksheet(at: path)
                
                var startTopicSel = 0
                var endTopicSel = 0
                
                // Get Cell Data
                let lowerUpperPri = worksheet.cells(atColumns: [ColumnReference("A")!])
                    .compactMap{ $0.stringValue(sharedStrings) }
                let topic = worksheet.cells(atColumns: [ColumnReference("B")!])
                    .compactMap { $0.stringValue(sharedStrings) }
                                
                // Find Rows of Selected Topic
                let findTopicSelectedStart = topic.firstIndex(of: selectedLesson)
                if findTopicSelectedStart != nil {
                    startTopicSel = Int(findTopicSelectedStart ?? 0)
                }
                
                let findTopicSelectedEnd = topic.lastIndex(of: selectedLesson)
                if findTopicSelectedEnd != nil {
                    endTopicSel = Int(findTopicSelectedEnd ?? 0)
                }
                if (startTopicSel - endTopicSel >= 0) {
                    MotionToast(message: "No Known Quiz", toastType: .error, toastStyle: .style_vibrant, toastGravity: .centre, toastCornerRadius: 10)
                    MCQBtn.isEnabled = false
                    MCQBtn.isHidden = true
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Clip to Bounds
        MCQBtn.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        MCQBtn.layer.cornerRadius = 20
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
        
        userDefaults.set(selectedLesson, forKey: "User Selected Lesson")
        userDefaults.synchronize()
        
        topicSelectionView.isHidden = false
        subtopicTableView.isHidden = true
        quizSelectionView.isHidden = true
        
        // Set Delegate and Data Source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Collect Data
        worksheetName = "\(primaryLevel) Data"
                
        getData()
        getMainData()
    }
    
    func frequentlyOpened(lesson: String) {
        var frequentlyOpened:[String:Int] = [:]
        
        if let frequentlyOpened1 = userDefaults.object(forKey: "Frequently Opened") as? [String:Int] {
            frequentlyOpened = frequentlyOpened1
        } else {
            frequentlyOpened = [:]
        }
        
        if (frequentlyOpened[lesson] != nil) {
            // Frequently Opened aleardy has the lesson
            var timesOpened = 0
            
            if let timesOpened1 = frequentlyOpened[lesson] {
                timesOpened = timesOpened1
            }
            
            timesOpened += 1
            frequentlyOpened[lesson] = timesOpened

            userDefaults.set(frequentlyOpened, forKey: "Frequently Opened")
            
        } else {
            // Frequently Opened has no lesson
            var timesOpened = 0

            timesOpened += 1
            frequentlyOpened[lesson] = timesOpened
            
            userDefaults.set(frequentlyOpened, forKey: "Frequently Opened")
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
        
        if userSelectedTopic[indexPath.row] != "" {
            userDefaults.set(userSelectedTopic[indexPath.row], forKey: "Overall Selected Topic")
            frequentlyOpened(lesson: userSelectedTopic[indexPath.row])
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
            confirmQuiz()
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
}
