//
//  FlashcardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 22/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class FlashcardsViewController: UIViewController {
    
    // UI Elements
    @IBOutlet weak var conceptNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var flashcardBG: UIView!
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
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
    var overallTopics:Array<String> = []
    var isFlashcardNil = false
    
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
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

    func checkFavourited(needUpdate: Bool) {
        if needUpdate {
            let amtOfFavouritedFlashcards = favouriteFlashcard.count
            
            if (amtOfFavouritedFlashcards != 0) {
                if (amtOfFavouritedFlashcards == 1) {
                    if (conceptName == favouriteFlashcard[0]) {
                        isFlashcardFavourited = true
                    } else {
                        isFlashcardFavourited = false
                    }
                } else {
                    for i in 0...amtOfFavouritedFlashcards - 1 {
                        if (conceptName == favouriteFlashcard[i]) {
                            isFlashcardFavourited = true
                        } else {
                            isFlashcardFavourited = false
                        }
                    }
                }
            } else {isFlashcardFavourited = false}
        
            if (isFlashcardFavourited) {
                print("\(conceptName) is now not Favourited")
                favouriteFlashcard = favouriteFlashcard.remove(conceptName)
                if let image = UIImage(named: "heart.empty") {
                    favouriteButton.setImage(image, for: .normal)
                } else {
                    fatalError("Image does not exist or is corrupted.")
                }
            } else {
                print("\(conceptName) is now Favourited")
                favouriteFlashcard.append(conceptName)
                if let image = UIImage(named: "heart.fill") {
                    favouriteButton.setImage(image, for: .normal)
                } else {
                    fatalError("Image does not exist or is corrupted.")
                }
            }
            
            userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
        } else {
            let amtOfFavouritedFlashcards = favouriteFlashcard.count
            
            if (amtOfFavouritedFlashcards != 0) {
                if (amtOfFavouritedFlashcards == 1) {
                    if (conceptName == favouriteFlashcard[0]) {
                        isFlashcardFavourited = true
                    } else {
                        isFlashcardFavourited = false
                    }
                } else {
                    for i in 0...amtOfFavouritedFlashcards - 1 {
                        if (conceptName == favouriteFlashcard[i]) {
                            isFlashcardFavourited = true
                        } else {
                            isFlashcardFavourited = false
                        }
                    }
                }
            } else {isFlashcardFavourited = false}
        
            if (isFlashcardFavourited) {
                print("\(conceptName) is Favourited")
                if let image = UIImage(named: "heart.fill") {
                    favouriteButton.setImage(image, for: .normal)
                } else {
                    fatalError("Image does not exist or is corrupted.")
                }
            } else {
                print("\(conceptName) is not Favourited")
                if let image = UIImage(named: "heart.empty") {
                    favouriteButton.setImage(image, for: .normal)
                } else {
                    fatalError("Image does not exist or is corrupted.")
                }
            }
        }
    }
    
    var storedFlashcardIndex = 0
    var storedFlashcardData:Array<String> = []
    
    func configFlashcards() {
        currentFlashcard.removeAll()
        checkFavourited(needUpdate: false)
                
        if (flashcardsIndex == 1) {
            currentFlashcard = data["Flashcard \(flashcardsIndex)"]!
        } else {
            if (data["Flashcard \(flashcardsIndex)"] == nil) {
                currentFlashcard = data["Flashcard \(flashcardsIndex - 1)"]!
                isFlashcardNil = true
            } else {
                currentFlashcard = data["Flashcard \(flashcardsIndex)"]!
                isFlashcardNil = false
            }
        }
        
        conceptName = currentFlashcard[3]
        
        conceptNameLabel.numberOfLines = 0; // Dynamic number of lines
        conceptNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        conceptNameLabel.text = conceptName
        
        uneditedCurrentFlashcard = currentFlashcard
        currentFlashcard.removeSubrange(0..<4)
        
        let flashcardKnowledge = currentFlashcard.joined(separator: "\n")
        textField.text = "\(flashcardKnowledge)"
        
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
        
        if let rowStart:Int = userDefaults.integer(forKey: "TopicSelStart") as? Int {
            topicSelRowStart = rowStart
        }
        
        if let rowEnd:Int = userDefaults.integer(forKey: "TopicSelEnd") as? Int{
            topicSelRowEnd = rowEnd
        }
        
        if let favFlashcard = userDefaults.object(forKey: "Favourite Flashcard") as? Array<String> {
            favouriteFlashcard = favFlashcard
        }
        
        // Set Label Text
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
        
        // Config Concept Label
        conceptNameLabel.numberOfLines = 3; // Dynamic number of lines
        conceptNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        // Init Page Data
        getData()
        configFlashcards()
        checkFavourited(needUpdate: false)
        updateSwipeLabel()
        
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {
        checkFavourited(needUpdate: true)
    }
    
    @objc func swipeRight(_ swipeGesture: UISwipeGestureRecognizer?=nil) {
        if (!isFlashcardNil && flashcardsIndex>1) {
            flashcardsIndex -= 1
        
        
        
            if (lessonsSelRowEnd - lessonsSelRowStart != flashcardsIndex) {
                let tF = true
                
                flashcardBG.flashcardAnimation(r2lDirection: tF)
                
                configFlashcards()
                checkFavourited(needUpdate: false)
            }
        }
        if (flashcardsIndex<=1){
            if (flashcardsIndex>=data.count-1){
                swipeLabel.text="This is the only flashcard"
            }else{
                swipeLabel.text="Swipe Right to see more"
            }
        }else if (flashcardsIndex>=data.count-1){
            swipeLabel.text="Swipe Left to see more"
        }else{
            swipeLabel.text="Swipe Right/Left to see more"
        }
        updateSwipeLabel()
    }
    
    @objc func swipeLeft(_ swipeGesture: UISwipeGestureRecognizer?=nil) {
        
        if (!isFlashcardNil && flashcardsIndex<data.count-1) {
            flashcardsIndex += 1
            if (lessonsSelRowEnd - lessonsSelRowStart != flashcardsIndex) {
                let tF = false
                
                flashcardBG.flashcardAnimation(r2lDirection: tF)
                
                configFlashcards()
                checkFavourited(needUpdate: false)
            }
        }
        updateSwipeLabel()
    }
    func updateSwipeLabel(){
        if (flashcardsIndex<=1){
            if (flashcardsIndex>=data.count-1){
                swipeLabel.text="This is the only flashcard"
            }else{
                swipeLabel.text="Swipe Right to see more"
            }
        }else if (flashcardsIndex>=data.count-1){
            swipeLabel.text="Swipe Left to see more"
        }else{
            swipeLabel.text="Swipe Right/Left to see more"
        }
    }
    @IBAction func simulateSwipeRight(_ sender: Any) {
        swipeRight()
    }
    
    @IBAction func simulateSwipeLeft(_ sender: Any) {
        swipeLeft()
    }
}
