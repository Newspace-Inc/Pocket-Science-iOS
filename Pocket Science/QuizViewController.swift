//
//  QuizViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 13/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class QuizViewController: UIViewController {
    
    // Variales
    var recentlyOpenedLevel:String = ""
    var dataPassCheck:Bool = false
    var primaryLevel:String = ""
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0
    var quizType = ""
    var userPoints = 0
    var selectedLesson = ""
    var userSelectedTopic = [""]
    var correctAns = ""
    var correctQnName = [""]
    var incorrectQnName = [""]
    var currentQn = ""
    
    var quizQuestionIndex = 1
    var currentQuizQn = [""]
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionThreeBtn: UIButton!
    @IBOutlet weak var optionFourBtn: UIButton!
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var primarySchoolLvel: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionView: UITextView!
    
    // Views
    @IBOutlet weak var spellingView: UIView!
    @IBOutlet weak var MCQView: UIView!
    
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
                
                totalAmtOfQns = endTopicSel - startTopicSel - 1
                 
                if (startTopicSel + (quizQuestionIndex - 1) <= endTopicSel) {
                    currentQuizQn = worksheet.cells(atRows: [UInt(startTopicSel + quizQuestionIndex)])
                        .compactMap { $0.stringValue(sharedStrings) }
                }
                
                currentQuizQn.removeSubrange(0..<2)
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func quizConfig() {
        if (quizType == "Multiple Choice Questions") {
            questionNumber.text = "\(quizQuestionIndex)/\(totalAmtOfQns)"
            print(currentQuizQn)
            currentQn = currentQuizQn[0]
            questionView.text = currentQn
            correctAns = currentQuizQn.last ?? "NIL"
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
        } else if (quizType == "Spelling") {
            
        }
    }
    
    
    func initQuiz() {
        amtOfCorrectAns = 0
        amtOfPointsEarned = 0
        totalAmtOfQns = 0
        correctAns = ""
        correctQnName = [""]
        incorrectQnName = [""]
        currentQn = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") {
            userPoints = userPointsGrab
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        if let selectedQuizType = userDefaults.string(forKey: "Quiz Type") {
            quizType = selectedQuizType
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
        }
        
        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        optionOneBtn.clipsToBounds = true
        optionTwoBtn.clipsToBounds = true
        optionThreeBtn.clipsToBounds = true
        optionFourBtn.clipsToBounds = true
        
        // Set Corner Radius
        uiBG?.layer.cornerRadius = 20
        optionOneBtn.layer.cornerRadius = 20
        optionTwoBtn.layer.cornerRadius = 20
        optionThreeBtn.layer.cornerRadius = 20
        optionFourBtn.layer.cornerRadius = 20
        
        // Set Label Names
        quizTypeLabel.text = quizType
        primarySchoolLvel.text = "\(primaryLevel) \(selectedLesson)"
        
        // Change Quiz Type
        if (quizType == "Multiple Choice Questions") {
            spellingView.isHidden = true
            MCQView.isHidden = false
        } else if (quizType == "Spelling") {
            spellingView.isHidden = false
            MCQView.isHidden = true
        }
        
        getData()
        quizConfig()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultsViewController
        destinationVC.primaryLevel = primaryLevel
        destinationVC.amtOfCorrectAns = amtOfCorrectAns
        destinationVC.amtOfPointsEarned = amtOfPointsEarned
        destinationVC.totalAmtOfQns = totalAmtOfQns
    }
    
    @IBAction func optionOneBtn(_ sender: Any) {
        quizQuestionIndex += 1
        
        if (optionOneBtn.currentTitle == correctAns) {
            correctQnName.append(currentQn)
        } else {
            incorrectQnName.append(currentQn)
        }
        
        print(totalAmtOfQns)
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            userDefaults.set(totalAmtOfQns,forKey: "Total amount of Quiz Qns")
            userDefaults.set(correctQnName, forKey: "Correct Qns Array")
            userDefaults.set(incorrectQnName, forKey: "Incorrect Qns Array")
            performSegue(withIdentifier: "quizResults", sender: nil)
        } else {
            getData()
            quizConfig()
        }
    }
    
    @IBAction func optionTwoBtn(_ sender: Any) {
        quizQuestionIndex += 1
        
        if (optionTwoBtn.currentTitle == correctAns) {
            correctQnName.append(currentQn)
        } else {
            incorrectQnName.append(currentQn)
        }
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            userDefaults.set(totalAmtOfQns,forKey: "Total amount of Quiz Qns")
            userDefaults.set(correctQnName, forKey: "Correct Qns Array")
            userDefaults.set(incorrectQnName, forKey: "Incorrect Qns Array")
            performSegue(withIdentifier: "quizResults", sender: nil)
        } else {
            getData()
            quizConfig()
        }
    }
    
    @IBAction func optionThreeBtn(_ sender: Any) {
        quizQuestionIndex += 1
        
        if (optionThreeBtn.currentTitle == correctAns) {
            correctQnName.append(currentQn)
        } else {
            incorrectQnName.append(currentQn)
        }
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            userDefaults.set(totalAmtOfQns,forKey: "Total amount of Quiz Qns")
            userDefaults.set(correctQnName, forKey: "Correct Qns Array")
            userDefaults.set(incorrectQnName, forKey: "Incorrect Qns Array")
            performSegue(withIdentifier: "quizResults", sender: nil)
        } else {
            getData()
            quizConfig()
        }
    }
    
    @IBAction func optionFourBtn(_ sender: Any) {
        quizQuestionIndex += 1
        
        if (optionFourBtn.currentTitle == correctAns) {
            correctQnName.append(currentQn)
        } else {
            incorrectQnName.append(currentQn)
        }
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            userDefaults.set(totalAmtOfQns,forKey: "Total amount of Quiz Qns")
            userDefaults.set(correctQnName, forKey: "Correct Qns Array")
            userDefaults.set(incorrectQnName, forKey: "Incorrect Qns Array")
            performSegue(withIdentifier: "quizResults", sender: nil)
        } else {
            getData()
            quizConfig()
        }
    }
    @IBAction func retryQuiz( _ seg: UIStoryboardSegue) {
        self.loadView()
    }
}
