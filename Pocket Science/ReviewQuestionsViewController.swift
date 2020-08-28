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
    var currentQuestion = ""
    var questionAnswer = ""
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
                
                questionView.text = currentQuizQn[2]
                currentQuestion = questionView.text
                questionAnswer = currentQuizQn[6]
                
                currentQuizQn.removeSubrange(0..<2)
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func quizConfig() {
        questionNumber.text = "\(quizQuestionIndex)/\(totalAmtOfQns)"
        currentQuizQn.removeFirst()
        for i in 0...3 {
            currentQuizQn.shuffle()
        }
        
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
        if (quizQuestionIndex == totalAmtOfQns) {
            
        } else {
            // Check Correct/Wrong
            
            if (questionAnswer == optionOneBtn.currentTitle) { // Check if the text of button one is the correct answer
                optionOneBtn.backgroundColor = UIColor.systemGreen
                optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                optionFourBtn.backgroundColor = UIColor.secondaryLabel
            } else if (questionAnswer == optionTwoBtn.currentTitle) { // Check if the text of button two is the correct answer
                optionTwoBtn.backgroundColor = UIColor.systemGreen
                optionOneBtn.backgroundColor = UIColor.secondaryLabel
                optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                optionFourBtn.backgroundColor = UIColor.secondaryLabel
            } else if (questionAnswer == optionThreeBtn.currentTitle) { // Check if the text of button three is the correct answer
                optionThreeBtn.backgroundColor = UIColor.systemGreen
                optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                optionOneBtn.backgroundColor = UIColor.secondaryLabel
                optionFourBtn.backgroundColor = UIColor.secondaryLabel
            } else if (questionAnswer == optionFourBtn.currentTitle) { // Check if the text of button four is the correct answer
                optionFourBtn.backgroundColor = UIColor.systemGreen
                optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                optionOneBtn.backgroundColor = UIColor.secondaryLabel
            }
            
            if (correctQnName.count == 0) { // User got all questions incorrect
                for i in 0...incorrectQnName.count - 1 {
                    if (optionOneBtn.currentTitle == incorrectQnName[i]) {
                        optionOneBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionTwoBtn.currentTitle == incorrectQnName[i]) {
                        optionTwoBtn.backgroundColor = UIColor.systemRed
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionThreeBtn.currentTitle == incorrectQnName[i]) {
                        optionThreeBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionFourBtn.currentTitle == incorrectQnName[i]) {
                        optionFourBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                    } else {
                        fatalError("Incorrect Qns not found")
                    }
                }
            } else { // User got at least 1 question correct
                for i in 0...incorrectQnName.count - 1 {
                    if (optionOneBtn.currentTitle == incorrectQnName[i]) {
                        print(optionOneBtn.currentTitle == incorrectQnName[i])
                        optionOneBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionTwoBtn.currentTitle == incorrectQnName[i]) {
                        print(optionTwoBtn.currentTitle == incorrectQnName[i])
                        optionTwoBtn.backgroundColor = UIColor.systemRed
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionThreeBtn.currentTitle == incorrectQnName[i]) {
                        print(optionThreeBtn.currentTitle == incorrectQnName[i])
                        optionThreeBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                        optionFourBtn.backgroundColor = UIColor.secondaryLabel
                    } else if (optionFourBtn.currentTitle == incorrectQnName[i]) {
                        print(optionFourBtn.currentTitle == incorrectQnName[i])
                        optionFourBtn.backgroundColor = UIColor.systemRed
                        optionTwoBtn.backgroundColor = UIColor.secondaryLabel
                        optionThreeBtn.backgroundColor = UIColor.secondaryLabel
                        optionOneBtn.backgroundColor = UIColor.secondaryLabel
                    }
                }
            }
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
        print(quizQuestionIndex)
        
        getData()
        quizConfig()
    }
}
