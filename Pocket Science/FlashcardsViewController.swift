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
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var conceptNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var bgPadding: UILabel!
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
    
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults.standard
    
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
        imageView.clipsToBounds = true
        bgPadding.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Curved Corners
        imageView.layer.cornerRadius = 20
        bgPadding.layer.cornerRadius = 20
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
            } else {
                fatalError("Image does not exist or is corrupted.")
            }
        }
        
        print(favouriteFlashcard)
        print(isFlashcardFavourited)
        
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

            getData()
            checkFavourited()
        } else if (swipeGesture.direction == .right) {
            flashcardsIndex += 1
            
            if (flashcardsIndex < 0) {
                flashcardsIndex = 0
            }
            
            
            getData()
            checkFavourited()
        }
    }
}
