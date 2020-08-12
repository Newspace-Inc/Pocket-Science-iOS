//
//  FavouriteFlashcardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 23/7/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class FavouriteFlashcardsViewController: UIViewController {
    
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
    var selectedFavouriteFlashcard = ""
    var flashcardData = [""]
    var flashcardRowNum:Array<Int> = []
    
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var conceptNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var flashcardBG: UIView!
    @IBOutlet weak var UIBG: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    
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
        
        if let favouriteSelected = userDefaults.string(forKey: "Selected Favourite Flashcard") {
            selectedFavouriteFlashcard = favouriteSelected
        }
        
        if let favouritedNum = userDefaults.object(forKey: "Favourited Row Number") as? [Int] ?? [] {
            flashcardRowNum = favouritedNum
        }
        
        if let favourited:Array<String> = userDefaults.object(forKey: "Favourite Flashcard") as? [String] ?? [String](){
            favouriteFlashcard = favourited
        }
        
        // Set Clip to Bounds
        UIBG.clipsToBounds = true
        flashcardBG.clipsToBounds = true
        
        // Curved Corners
        UIBG.layer.cornerRadius = 20
        flashcardBG.layer.cornerRadius = 20
        
        getData()
        checkFavourited()
    }
    
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
                                
                // Find Rows of Selected Topic
                let firstIndex = favouriteFlashcard.firstIndex(of: selectedFavouriteFlashcard) ?? 0
                
                print(flashcardRowNum)
                print(favouriteFlashcard)
                let index = flashcardRowNum[firstIndex]
                
                currentFlashcard = worksheet.cells(atRows: [UInt(index)])
                    .compactMap { $0.stringValue(sharedStrings) }
                currentFlashcard = currentFlashcard.remove("Empty Cell")
                
                conceptName = selectedFavouriteFlashcard
                conceptNameLabel.text = "\(conceptName)"
                
                uneditedCurrentFlashcard = currentFlashcard
                currentFlashcard.removeSubrange(0..<4)
                
                let flashcardKnowledge = currentFlashcard.joined(separator: "\n")
                
                textField.text = "\(flashcardKnowledge)"
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
    
    @IBAction func favouriteBtn(_ sender: Any) {
        getData()
        checkFavourited()
        
        if (isFlashcardFavourited == true) {
            // Remove Favourite
            let count = favouriteFlashcard.count - 1
            
            for i in 0...count {
                if (uneditedCurrentFlashcard[2] == favouriteFlashcard[i]) {
                    favouriteFlashcard.remove(at: i)
                    print(flashcardRowNum)
                    flashcardRowNum.remove(at: i)
                    userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
                    userDefaults.set(flashcardRowNum, forKey: "Favourited Row Number")
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
        
        if (favouriteFlashcard != [""]) {
            userDefaults.set(favouriteFlashcard, forKey: "Favourite Flashcard")
        }
    }
    
}
