//
//  QuizViewController1.swift
//  Pocket Science
//
//  Created by Ethan Chew on 9/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class QuizViewController1: UIViewController {
    
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
    
    // Quiz Config
    var correctAns = ""
    var correctQnName = [""]
    var currentQn = ""
    var data: [String:[String]] = [:]
    var quizQuestionIndex = 1
    var userSelectedOption = ""
    var didSelectOption = false
    let buttonSelectColour = UIColor(red: 134/255, green: 154/255, blue: 255/255, alpha: 1)
    var correctQuestions: [String] = []
    var incorrectQuestions: [String] = []
    
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
    @IBOutlet weak var submitBtn: UIButton!
    
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
                    var index = endTopicSel - startTopicSel - 1
                    
                    for i in 0...index {
                        let parseData = worksheet.cells(atRows: [UInt(startTopicSel + i + 1)])
                            .compactMap { $0.stringValue(sharedStrings) }
                        data["Data \(i + 1)"] = parseData
                    }
                }
                
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func resetButtonColours() {
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
    }
    
    func quizConfig() {
        var currentQuizQn: [String] = []
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            submitBtn.setTitle("Finish", for: .normal)
        } else {
            if (data["Data \(currentQuizQn)"] != nil) {
                currentQuizQn = data["Data \(currentQuizQn)"]!
            } else {
                currentQuizQn = data["Data \(currentQuizQn)"]!
            }
            
            questionView.text = currentQuizQn[0] // Question will always be at index 0 of the array
            currentQuizQn.remove(at: 0) // Remove Question from the array
            correctAns = currentQuizQn[3] // Last option will always be the answer
            
            // Shuffle the options
            for _ in 0...5 {
                currentQuizQn.shuffle()
            }
            
            // Configure the Buttons
            optionOneBtn.titleLabel?.numberOfLines = 0;
            optionOneBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionTwoBtn.titleLabel?.numberOfLines = 0;
            optionTwoBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionThreeBtn.titleLabel?.numberOfLines = 0;
            optionThreeBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionFourBtn.titleLabel?.numberOfLines = 0;
            optionFourBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            
            // Configure the Options
            optionOneBtn.setTitle(currentQuizQn[0], for: .normal)
            optionTwoBtn.setTitle(currentQuizQn[1], for: .normal)
            optionThreeBtn.setTitle(currentQuizQn[2], for: .normal)
            optionFourBtn.setTitle(currentQuizQn[3], for: .normal)
            
            // Set the question number
            questionNumber.text = "Question \(quizQuestionIndex)/10"
            
            // Set the text of the submit button back to submit
            submitBtn.setTitle("Submit", for: .normal)
            
            resetButtonColours()
        }
    }
    
    func checkAnswer() {
        let originalColour = UIColor.systemGray
        let correctColour = UIColor.systemGreen
        let incorrectColour = UIColor.systemRed
        
        // Reset all button colours
        resetButtonColours()
        
        // Check what button has the correct answer
        if (optionOneBtn.currentTitle == correctAns) {
            optionOneBtn.backgroundColor = correctColour
        } else if (optionTwoBtn.currentTitle == correctAns) {
            optionTwoBtn.backgroundColor = correctColour
        } else if (optionThreeBtn.currentTitle == correctAns) {
            optionThreeBtn.backgroundColor = correctColour
        } else if (optionFourBtn.currentTitle == correctAns) {
            optionFourBtn.backgroundColor = correctColour
        }
        
        if (userSelectedOption != correctAns) { // User got the question wrong
            incorrectQuestions.append("Question \(quizQuestionIndex)")
            if (optionOneBtn.currentTitle == userSelectedOption) {
                optionOneBtn.backgroundColor = incorrectColour
            } else if (optionTwoBtn.currentTitle == userSelectedOption) {
                optionTwoBtn.backgroundColor = incorrectColour
            } else if (optionThreeBtn.currentTitle == userSelectedOption) {
                optionThreeBtn.backgroundColor = incorrectColour
            } else if (optionFourBtn.currentTitle == userSelectedOption) {
                optionFourBtn.backgroundColor = incorrectColour
            }
        } else {
            correctQuestions.append("Question \(quizQuestionIndex)")
        }
        
        if (quizQuestionIndex == totalAmtOfQns + 1) {
            submitBtn.setTitle("Finish", for: .normal)
        } else {
            submitBtn.setTitle("Next", for: .normal)
        }
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
        
        
    }
    
    @IBAction func optionOneBtn(_ sender: Any) {
        userSelectedOption = optionOneBtn.currentTitle!
        
        optionOneBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        didSelectOption = true
    }
    
    @IBAction func optionTwoBtn(_ sender: Any) {
        userSelectedOption = optionTwoBtn.currentTitle!
        
        optionTwoBtn.backgroundColor = buttonSelectColour
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        didSelectOption = true
    }
    
    @IBAction func optionThreeBtn(_ sender: Any) {
        userSelectedOption = optionThreeBtn.currentTitle!
        
        optionThreeBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        didSelectOption = true
    }
    
    @IBAction func optionFourBtn(_ sender: Any) {
        userSelectedOption = optionFourBtn.currentTitle!
        
        optionFourBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionOneBtn.backgroundColor = UIColor.systemGray
        
        didSelectOption = true
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if (submitBtn.currentTitle == "Submit") {
            if (didSelectOption) {
                checkAnswer()
                didSelectOption = false
            } else {
                let alert = UIAlertController(title: "Please select a option before submitting!", message: "You can't submit a blank answer script during an exam right?", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        } else if (submitBtn.currentTitle == "Next") {
            quizQuestionIndex += 1
            quizConfig()
        } else if (submitBtn.currentTitle == "Finish") {
            userDefaults.set(correctQuestions, forKey: "Correct Questions")
            userDefaults.set(incorrectQuestions, forKey: "Incorrect Questions")
            
            performSegue(withIdentifier: "reviewScore", sender: nil)
        }
    }
}
