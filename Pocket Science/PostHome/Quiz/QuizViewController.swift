
//
//  QuizViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 9/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//
import UIKit
import CoreXLSX

class QuizViewController: UIViewController {
    
    // Variales
    var recentlyOpenedLevel:String = ""
    var userSelected:Bool = false
    var primaryLevel:String = ""
    var amtOfCorrectAns:Int = 0
    var amtOfPointsEarned:Int = 0
    var totalAmtOfQns:Int = 0
    var quizType = ""
    var userPoints = 0
    var selectedLesson = ""
    var userSelectedTopic = [""]
    var submittedAnswer=false
    
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
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    
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
                var index = endTopicSel - startTopicSel - 1
                if index < 0 {
                    MotionToast(message: "No Known Quiz", toastType: .error,
                                  duration: .long, toastStyle: .style_pale, toastGravity: .top)
                } else {
                    if (startTopicSel + (quizQuestionIndex - 1) <= endTopicSel) {
                        for i in 0...index {
                            let parseData = worksheet.cells(atRows: [UInt(startTopicSel + i + 1)])
                                .compactMap { $0.stringValue(sharedStrings) }
                            data["Data \(i + 1)"] = parseData
                        }
                        totalAmtOfQns = index
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
            if (data["Data \(quizQuestionIndex)"] != nil) {
                currentQuizQn = data["Data \(quizQuestionIndex)"]!
            } else {
                currentQuizQn = data["Data \(quizQuestionIndex)"]!
            }
            
            
            
            
            questionView.text = currentQuizQn[2] // Question will always be at index 0 of the array
            currentQuizQn.remove(at: 0) // Remove Question from the array(small brain it just removes the topic)
            correctAns = currentQuizQn[5] // Last option will always be the answer(small brain it is the 'last' option which is the first option because you iterated from the fron back)
            
            // Shuffle the options
            print(currentQuizQn)
            currentQuizQn=[currentQuizQn[2],currentQuizQn[3],currentQuizQn[4],currentQuizQn[5]]
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
            questionNumber.text = "Question \(quizQuestionIndex)/\(totalAmtOfQns)"
            
            // Set the text of the submit button back to submit
            submitBtn.setTitle("Submit", for: .normal)
            
            resetButtonColours()
        }
    }
    
    func checkAnswer() {
        let originalColour = UIColor.systemGray
        let correctColour = UIColor.systemGreen
        let incorrectColour = UIColor.systemRed
        userSelected = true
        
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
        
        if (quizQuestionIndex == totalAmtOfQns ) {
            submitBtn.setTitle("Finish", for: .normal)
        } else {
            submitBtn.setTitle("Next", for: .normal)
        }
        userSelected = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int{
            userPoints = userPointsGrab
        }
        
        if let priSchLvl = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = priSchLvl
        }
        
        if let selectedQuizType = userDefaults.string(forKey: "Quiz Type") {
            quizType = selectedQuizType
        }
        //print(quizType)
        
        if let openedLesson = userDefaults.string(forKey: "User Selected Lesson")  {
            selectedLesson = openedLesson
            //print(selectedLesson)
        } else {
            //selectedLesson="Cycles"
            fatalError("Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value(probablyi)")
        }
        
        
        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        optionOneBtn.clipsToBounds = true
        optionTwoBtn.clipsToBounds = true
        optionThreeBtn.clipsToBounds = true
        optionFourBtn.clipsToBounds = true
        submitBtn.clipsToBounds = true
        
        // Set Corner Radius
        uiBG?.layer.cornerRadius = 20
        optionOneBtn.layer.cornerRadius = 10
        optionTwoBtn.layer.cornerRadius = 10
        optionThreeBtn.layer.cornerRadius = 10
        optionFourBtn.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 15
        
        // Set Label Names
        quizTypeLabel.text = quizType
        primarySchoolLvel.text = "\(primaryLevel) \(selectedLesson)"
        
        // Change Quiz Type
        //                if (quizType == "Multiple Choice Questions") {
        //                    spellingView.isHidden = true
        //                    MCQView.isHidden = false
        //                } else if (quizType == "Spelling") {
        //                    spellingView.isHidden = false
        //                    MCQView.isHidden = true
        //                }

        getData()
        quizConfig()
    }
    
    @IBAction func optionOneBtn(_ sender: Any) {
        userSelectedOption = optionOneBtn.currentTitle!
        
        if (userSelected || submittedAnswer) {
            
        } else {
            optionOneBtn.backgroundColor = buttonSelectColour
            optionTwoBtn.backgroundColor = UIColor.systemGray
            optionThreeBtn.backgroundColor = UIColor.systemGray
            optionFourBtn.backgroundColor = UIColor.systemGray
        }
        
        didSelectOption = true
    }
    
    @IBAction func optionTwoBtn(_ sender: Any) {
        userSelectedOption = optionTwoBtn.currentTitle!
        
        if (userSelected || submittedAnswer) {
            
        } else {
            optionTwoBtn.backgroundColor = buttonSelectColour
            optionOneBtn.backgroundColor = UIColor.systemGray
            optionThreeBtn.backgroundColor = UIColor.systemGray
            optionFourBtn.backgroundColor = UIColor.systemGray
        }
        
        didSelectOption = true
    }
    
    @IBAction func optionThreeBtn(_ sender: Any) {
        userSelectedOption = optionThreeBtn.currentTitle!
        
        if (userSelected || submittedAnswer) {
            
        } else {
            optionThreeBtn.backgroundColor = buttonSelectColour
            optionTwoBtn.backgroundColor = UIColor.systemGray
            optionOneBtn.backgroundColor = UIColor.systemGray
            optionFourBtn.backgroundColor = UIColor.systemGray
        }
            
        didSelectOption = true
    }
    
    @IBAction func optionFourBtn(_ sender: Any) {
        userSelectedOption = optionFourBtn.currentTitle!
        if (userSelected || submittedAnswer) {
            
        } else {
            optionFourBtn.backgroundColor = buttonSelectColour
            optionTwoBtn.backgroundColor = UIColor.systemGray
            optionThreeBtn.backgroundColor = UIColor.systemGray
            optionOneBtn.backgroundColor = UIColor.systemGray
        }
        didSelectOption = true
    }
    
    @IBAction func answerBtn(_sender: Any) {
        if (submitBtn.currentTitle == "Submit") {
            if (didSelectOption) {
                submittedAnswer=true
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
            submittedAnswer=false
        } else if (submitBtn.currentTitle == "Finish") {
            userDefaults.set(correctQuestions, forKey: "Correct Questions")
            userDefaults.set(incorrectQuestions, forKey: "Incorrect Questions")
            userDefaults.set(totalAmtOfQns,forKey: "Total amount of Quiz Qns")
            performSegue(withIdentifier: "reviewScore", sender: nil)
        }
    }
    
}
