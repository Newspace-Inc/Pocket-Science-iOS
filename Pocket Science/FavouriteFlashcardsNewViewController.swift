//
//  FavouriteFlashcardsNewViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 10/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX
import MotionToastView

class FavouriteFlashcardsNewViewController: UIViewController {

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
    var flashcardData: [String:[String]] = [:]
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
                
                var index = 0
                
                if (firstIndex == 0) {
                    fatalError("Unknown Flashcard ID")
                } else {
                    index = flashcardRowNum[firstIndex]
                }
                
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
    
}
