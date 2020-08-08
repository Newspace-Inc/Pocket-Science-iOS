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
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
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
    var topicSelRowStart = 0
    var topicSelRowEnd = 0
    var flashcardsIndex = 0
    var isFlashcardFavourited:Bool = false
    var conceptName = ""
    var favouritedRowNum = [0]
    
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults.standard
    var r2lDirection = false  // Initialize to right to left swipe
    
    func getData() {
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
                
                if (topicSelRowStart + flashcardsIndex <= topicSelRowEnd) {
                    currentFlashcard = worksheet.cells(atRows: [UInt(topicSelRowStart + flashcardsIndex)])
                        .compactMap { $0.stringValue(sharedStrings) }
                    currentFlashcard = currentFlashcard.remove("Empty Cell")
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        conceptName = currentFlashcard[2]
        
        conceptNameLabel.numberOfLines = 3; // Dynamic number of lines
        conceptNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        conceptNameLabel.text = conceptName
                
        uneditedCurrentFlashcard = currentFlashcard
        currentFlashcard.removeSubrange(0..<4)
        
        let flashcardKnowledge = currentFlashcard.joined(separator: "\n")
        
        textField.text = "\(flashcardKnowledge)"
    }
    
    func checkFavourited() {
        let count = favouriteFlashcard.count - 1
        if (count == -1) {
            isFlashcardFavourited = false
        } else if (count == 0) {
            if (uneditedCurrentFlashcard[2] == favouriteFlashcard[0]) {
                isFlashcardFavourited = true
            } else {
                isFlashcardFavourited = false
            }
        } else {
            for i in 0...count {
                if (uneditedCurrentFlashcard[2] == favouriteFlashcard[i]) {
                    isFlashcardFavourited = true
                } else {
                    isFlashcardFavourited = false
                }
            }
        }
        
        if (isFlashcardFavourited == true) {
            if let image = UIImage(named: "heart.fill") {
                favouriteButton.setImage(image, for: .normal)
                favouritedRowNum.append(topicSelRowStart + flashcardsIndex)
                userDefaults.set(favouritedRowNum, forKey: "Favourited Row Number")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedOverall = userDefaults.string(forKey: "Overall Selected Topics") {
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
        
        getData()
        checkFavourited()
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {
        checkFavourited()
        
        if (isFlashcardFavourited == true) {
            // Remove Favourite
            let count = favouriteFlashcard.count - 1
            
            for i in 0...count {
                if (uneditedCurrentFlashcard[2] == favouriteFlashcard[i]) {
                    favouriteFlashcard.remove(at: i)
                    if let image = UIImage(named: "heart.empty") {
                        favouriteButton.setImage(image, for: .normal)
                    } else {
                        fatalError("Image does not exist or is corrupted.")
                    }
                }
            }
        } else {
            // Add Favourite
            favouriteFlashcard.append(uneditedCurrentFlashcard[2])
            if let image = UIImage(named: "heart.fill") {
                favouriteButton.setImage(image, for: .normal)
                favouritedRowNum.append(topicSelRowStart + flashcardsIndex)
                
                userDefaults.set(favouritedRowNum, forKey: "Favourited Row Number")
            } else {
                fatalError("Image does not exist or is corrupted.")
            }
        }
        
        
        if (favouriteFlashcard != [""]) {
            userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if swipeGesture.direction == .left {
            flashcardsIndex -= 1
            
            if (flashcardsIndex < 0) {
                flashcardsIndex = 0
            }
            
            flashcardBG.flashcardAnimation(r2lDirection: false)

            getData()
            checkFavourited()
        } else if (swipeGesture.direction == .right) {
            flashcardsIndex += 1
            
            if (flashcardsIndex < 0) {
                flashcardsIndex = 0
            }
            
            flashcardBG.flashcardAnimation(r2lDirection: true)
            
            getData()
            checkFavourited()
        }
    }
}
