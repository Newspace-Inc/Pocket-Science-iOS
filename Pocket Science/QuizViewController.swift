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
    
    // Views
    @IBOutlet weak var spellingView: UIView!
    @IBOutlet weak var MCQView: UIView!
    
    func getData() {
        // Collect Data
        let worksheetName = "Questions and Answers (\(primaryLevel))"
        
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
                print(totalAmtOfQns)
                
                if (startTopicSel + quizQuestionIndex <= endTopicSel) {
                    currentQuizQn = worksheet.cells(atRows: [UInt(startTopicSel + quizQuestionIndex)])
                        .compactMap { $0.stringValue(sharedStrings) }
                    print(currentQuizQn)
                }
                
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
    }
    
    func quizConfig() {
        if (quizType == "Multiple Choice Questions") {
            questionNumber.text = "\(quizQuestionIndex)/\(totalAmtOfQns)"
        } else if (quizType == "Spelling") {
            
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
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultsViewController
        destinationVC.primaryLevel = primaryLevel
        destinationVC.amtOfCorrectAns = amtOfCorrectAns
        destinationVC.amtOfPointsEarned = amtOfPointsEarned
        destinationVC.totalAmtOfQns = totalAmtOfQns
    }
    
}
