//
//  FlashcardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 22/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

extension UIView {
    func flashcardAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil, r2lDirection: Bool) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        if r2lDirection == true {
            leftToRightTransition.subtype = CATransitionSubtype.fromLeft
        } else {
            leftToRightTransition.subtype = CATransitionSubtype.fromRight
        }
        
        leftToRightTransition.type = CATransitionType.push
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        leftToRightTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
}

class FlashcardsViewController: UIViewController {
    
    // UI Elements
    @IBOutlet weak var conceptNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var flashcardBG: UIView!
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    // Variables
    var favouriteFlashcard:Array<String> = []
    var currentFlashcard:Array<String> = []
    var selectedOverallTopic = ""
    var selectedConcept = ""
    var primaryLevel = ""
    var selectedLesson = ""
    var topicSelRowStart = 0 // Starting Line Num of Selected Topic (eg Systems)
    var topicSelRowEnd = 0 // Ending Line Num of Selected Topic (eg Systems)
    var lessonsSelRowStart = 0 // Starting Line Num of Selected Lesson (eg How to make magnets)
    var lessonsSelRowEnd = 0 // Ending Line Num of Selected Lesson (eg How to make magnets)
    var flashcardsIndex = 1
    var isFlashcardFavourited:Bool = false
    var conceptName = ""
    var favouritedRowNum = [0]
    var overallTopics:Array<String> = []
    
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults.standard
    var r2lDirection = false  // Initialize to right to left swipe
    
    var data:[String:[String]] = [:]
    
    // Functions
    func getData() {
        // Clear old Dictonary
        data.removeAll()
        
        // Collect Data
        var worksheetName = ""
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
                var index = 1
                
                // Get Cell Data
                overallTopics = worksheet.cells(atColumns: [ColumnReference("C")!])
                    .compactMap { $0.stringValue(sharedStrings) }
                
                // Find Rows of Selected Lesson
                let findLessonSelectedStart = overallTopics.firstIndex(of: selectedOverallTopic) // Gets the first row of selected Lesson
                if findLessonSelectedStart != nil {
                    lessonsSelRowStart = Int(findLessonSelectedStart ?? 0) + 1
                }
                
                let findLessonSelectedEnd = overallTopics.lastIndex(of: selectedOverallTopic) // Gets the last row of selected Lesson
                if findLessonSelectedEnd != nil {
                    lessonsSelRowEnd = Int(findLessonSelectedEnd ?? 0) + 1
                }
                    for _ in lessonsSelRowStart...lessonsSelRowEnd - 1 {
                        if (lessonsSelRowStart + index <= lessonsSelRowEnd) {
                            var parsingFlashcards = worksheet.cells(atRows: [UInt(lessonsSelRowStart + index)])
                                .compactMap { $0.stringValue(sharedStrings) }
                            parsingFlashcards = parsingFlashcards.remove("Empty Cell")
                            
                            data["Flashcard \(index)"] = parsingFlashcards
                            index += 1
                        } 
                    }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func checkFavourited() {
        let count = favouriteFlashcard.count - 1
        if (count == -1) { // When count is -1, favouriteFlashcard.count = 0, meaning that there are no favourited items.
            isFlashcardFavourited = false
        } else if (count == 0) { // When count is 0, favouriteFlashcard.count = 1, meaning that there are at least 1 favourited items.
            for i in 0...favouriteFlashcard.count - 1 {
                if (conceptName == favouriteFlashcard[i]) {
                    isFlashcardFavourited = true
                } else {
                    isFlashcardFavourited = false
                }
            }
            
        } else {
            for i in 0...count {
                if (conceptName == favouriteFlashcard[i]) {
                    isFlashcardFavourited = true
                } else {
                    isFlashcardFavourited = false
                }
            }
        }
        
        if (isFlashcardFavourited == true) {
            if let image = UIImage(named: "heart.fill") {
                favouriteButton.setImage(image, for: .normal)
            } else {
                fatalError("Image does not exist or is corrupted.")
            }
        } else if (isFlashcardFavourited == false) {
            if let image = UIImage(named: "heart.empty") {
                favouriteButton.setImage(image, for: .normal)
            } else {
                fatalError("Image does not exist or is corrupted.")
            }
        }
    }
    
    var storedFlashcardIndex = 0
    var storedFlashcardData:Array<String> = []
    
    func configFlashcards() {
        currentFlashcard.removeAll()
                
        if ((data["Flashcard \(flashcardsIndex)"]) == nil) {
            if let tempData = data["Flashcard \(storedFlashcardIndex)"] {
                currentFlashcard = tempData
            } else {
                currentFlashcard = data["Flashcard \(storedFlashcardIndex)"]!
            }
        } else {
            if let tempData = data["Flashcard \(flashcardsIndex)"] {
                currentFlashcard = tempData
            } else {
                currentFlashcard = data["Flashcard \(flashcardsIndex)"]!
            }
            storedFlashcardIndex = flashcardsIndex
            storedFlashcardData = currentFlashcard
}
        
        conceptName = currentFlashcard[2]
        
        conceptNameLabel.numberOfLines = 3; // Dynamic number of lines
        conceptNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        conceptNameLabel.text = conceptName
        
        uneditedCurrentFlashcard = currentFlashcard
        currentFlashcard.removeSubrange(0..<4)
        
        var flashcardKnowledge = currentFlashcard.joined(separator: "\n")
        textField.text = "\(flashcardKnowledge)"
        
        checkFavourited()
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedOverall = userDefaults.string(forKey: "Overall Selected Topic") {
            selectedOverallTopic = selectedOverall
        }
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        if let openedLesson = userDefaults.string(forKey: "Opened Lesson") {
            selectedLesson = openedLesson
        }
        
        if let rowStart:Int = userDefaults.integer(forKey: "TopicSelStart") {
            topicSelRowStart = rowStart
        }
        
        if let rowEnd:Int = userDefaults.integer(forKey: "TopicSelEnd") {
            topicSelRowEnd = rowEnd
        }
        
        label1.text = "\(primaryLevel ?? "")"
        label2.text = "The \(primaryLevel ?? "") Syllabus"
        
        // Set Clip to Bounds
        flashcardBG.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Curved Corners
        flashcardBG.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
        // Config Swipe Gesture
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
                rightSwipeRecognizer.direction = .right
        self.view.addGestureRecognizer(rightSwipeRecognizer)
                
                let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
                leftSwipeRecognizer.direction = .left
        self.view.addGestureRecognizer(leftSwipeRecognizer)
        
        getData()
        configFlashcards()
        checkFavourited()
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {
        checkFavourited()
                
        if (isFlashcardFavourited == true) {
            // Remove Favourite
            let count = favouriteFlashcard.count - 1
            if (count != 0) {
                for i in 0...count {
                    if (conceptName == favouriteFlashcard[i]) {
                        favouriteFlashcard.remove(at: i)
                        favouriteFlashcard.remove(at: i)
                        if let image = UIImage(named: "heart.empty") {
                            favouriteButton.setImage(image, for: .normal)
                        } else {
                            fatalError("Image does not exist or is corrupted.")
                        }
                    }
                    userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
                    userDefaults.set(favouritedRowNum, forKey: "Favourited Row Number")
                }
            } else {
                favouriteFlashcard.remove(at: 0)
                favouriteFlashcard.remove(at: 0)
                
                if let image = UIImage(named: "heart.empty") {
                    favouriteButton.setImage(image, for: .normal)
                } else {
                    fatalError("Image does not exist or is corrupted.")
                }
                
                userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
                userDefaults.set(favouritedRowNum, forKey: "Favourited Row Number")
            }
        } else {
            // Add Favourite
            favouriteFlashcard.append(conceptName)
            favouritedRowNum.append(topicSelRowStart + flashcardsIndex)
            if let image = UIImage(named: "heart.fill") {
                favouriteButton.setImage(image, for: .normal)
            } else {
                fatalError("Image does not exist or is corrupted.")
            }
        }
        userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
        userDefaults.set(favouritedRowNum, forKey: "Favourited Row Number")
    }
    
    @objc func swipeRight(_ swipeGesture: UISwipeGestureRecognizer) {
        flashcardsIndex += 1
        
        if (flashcardsIndex < 0) {
            flashcardsIndex = 0
        }
        
        if (lessonsSelRowEnd - lessonsSelRowStart == flashcardsIndex) {
            print("End of Flashcards")
        } else {
            let tF = true
            
            flashcardBG.flashcardAnimation(r2lDirection: tF)
            
            configFlashcards()
            checkFavourited()
        }
        print(data.count)
        print(currentFlashcard)
    }
    
    @objc func swipeLeft(_ swipeGesture: UISwipeGestureRecognizer) {
        if (flashcardsIndex < 0) {
            flashcardsIndex = 0
        } else {
            flashcardsIndex -= 1
        }
        
        if (flashcardsIndex < 0) {
            flashcardsIndex = 0
        }
        
        if (lessonsSelRowEnd - lessonsSelRowStart == flashcardsIndex) {
            print("End of Flashcards")
        } else {
            let tF = false
            
            flashcardBG.flashcardAnimation(r2lDirection: tF)
            
            configFlashcards()
            checkFavourited()
        }
        print("\(lessonsSelRowEnd - lessonsSelRowStart) yes")
        
        print(data.count)
        print(currentFlashcard)
    }
}
