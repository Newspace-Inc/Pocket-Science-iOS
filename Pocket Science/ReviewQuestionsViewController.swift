//
//  ReviewQuestionsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 8/8/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class ReviewQuestionsViewController: UIViewController {
    
    // Variables
    var userName = ""
    var correctQnName = [""]
    var incorrectQnName = [""]
    var totalAmtOfQns:Int = 0
    var userPoints:Int = 0
    var primaryLevel = ""
    var selectedLesson = ""
    var quizQuestionIndex = 1
    var currentQuizQn:Array<String> = []
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionThreeBtn: UIButton!
    @IBOutlet weak var optionFourBtn: UIButton!
    @IBOutlet weak var primarySchoolLvel: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionView: UITextView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    func getData() {
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
                
                totalAmtOfQns = endTopicSel - startTopicSel
                
                if (startTopicSel + quizQuestionIndex <= endTopicSel) {
                    currentQuizQn = worksheet.cells(atRows: [UInt(startTopicSel + quizQuestionIndex)])
                        .compactMap { $0.stringValue(sharedStrings) }
                }
                
                currentQuizQn.removeSubrange(0..<2)
                print(currentQuizQn)
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func quizConfig() {
        questionNumber.text = "\(quizQuestionIndex)/\(totalAmtOfQns)"
        print(currentQuizQn)
        currentQuizQn.removeFirst()
        currentQuizQn.shuffle()
        
        // Set Button Lines
        optionOneBtn.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        optionOneBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        optionTwoBtn.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        optionTwoBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        optionThreeBtn.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        optionThreeBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        optionFourBtn.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        optionFourBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        // Set Button Title
        optionOneBtn.setTitle(currentQuizQn[0], for: .normal)
        optionTwoBtn.setTitle(currentQuizQn[1], for: .normal)
        optionThreeBtn.setTitle(currentQuizQn[2], for: .normal)
        optionFourBtn.setTitle(currentQuizQn[3], for: .normal)
        
        // Check Correct/Wrong
        for i in 0...currentQuizQn.count - 1 {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settingsUserName = userDefaults.string(forKey: "Username") {
            userName = settingsUserName
        } else {
            userName = "User"
        }
        
        if let correctQn = userDefaults.object(forKey: "Correct Qns Array") as? [String] ?? [] {
            correctQnName = correctQn
        }
        
        if let incorrectQn = userDefaults.object(forKey: "Incorrect Qns Array") as? [String] ?? [] {
            incorrectQnName = incorrectQn
        }
        
        if let amtOfQns:Int = userDefaults.integer(forKey: "Total amount of Quiz Qns") {
            totalAmtOfQns = amtOfQns
        }
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
        }
        
        // Save User Points
        if userPoints != 0 {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        getData()
        quizConfig()
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        quizQuestionIndex += 1
        
        getData()
        quizConfig()
    }
}
