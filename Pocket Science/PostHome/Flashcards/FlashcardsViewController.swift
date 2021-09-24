//
//  FlashcardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 22/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//
import UIKit

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
    var selectedOverallTopic:String = ""
    var selectedConcept:String = ""
    var primaryLevel:String = ""
    var selectedLesson:String = ""
    var topicSelRowStart:Int = 0// Starting Line Num of Selected Topic (eg Systems)
    var topicSelRowEnd:Int = 0// Ending Line Num of Selected Topic (eg Systems)
    var lessonsSelRowStart:Int = 0// Starting Line Num of Selected Lesson (eg How to make magnets)
    var lessonsSelRowEnd:Int = 0// Ending Line Num of Selected Lesson (eg How to make magnets)
    var flashcardsIndex = 1
    var isFlashcardFavourited:Bool = false
    var conceptName:String = ""
    var overallTopics:Array<String> = []
    var isFlashcardNil = false
    var conceptNames:[String] = []
    var flashcards:[String] = []
    var uneditedCurrentFlashcard:Array<String> = []
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    var r2lDirection = false  // Initialize to right to left swipe
    // Functions
    func getData() {
        // Clear old Dictonary
        var nsDictionary: [String:NSDictionary]
        let path = Bundle.main.path(forResource: "Main Data", ofType: "plist")
        nsDictionary = NSDictionary(contentsOfFile: path!) as! [String : NSDictionary]
        let prilevel:[String:[String:NSDictionary]] = nsDictionary[primaryLevel] as! [String : [String:NSDictionary]]
        
        conceptNames = prilevel[selectedLesson]![selectedOverallTopic]?.allKeys as! [String]
        
        for i in 0...conceptNames.count - 1 {
            flashcards.append(((prilevel[selectedLesson]![selectedOverallTopic]![conceptNames[i]] as! NSDictionary).allKeys as! [String]).joined(separator: "<br>"))
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
        
        conceptName = conceptNames[flashcardsIndex-1]
        
        conceptNameLabel.numberOfLines = 0; // Dynamic number of lines
        conceptNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        conceptNameLabel.text = conceptName
        let styles="""
        <head>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="">
        <link href="https://fonts.googleapis.com/css2?family=M+PLUS+Rounded+1c:wght@300&amp;display=swap" rel="stylesheet">
        </head>
        <body style="font-family: 'M PLUS Rounded 1c', sans-serif;">
        """
        let flashcardKnowledge = Data((styles + flashcards[flashcardsIndex-1] + "</body>").utf8)
        if let attributedString = try? NSAttributedString(data: flashcardKnowledge, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            textField.attributedText = attributedString
        }
        
        
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
        
        
        if let sl:String = userDefaults.string(forKey: "selectedLesson"){
            selectedLesson = sl
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
        updateSwipeLabel()
    }
    
    @objc func swipeLeft(_ swipeGesture: UISwipeGestureRecognizer?=nil) {
        
        if (!isFlashcardNil && flashcardsIndex<conceptNames.count-1) {
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
            if (flashcardsIndex>=conceptNames.count) {
                swipeLabel.text = "This is the Only Flashcard"
            } else {
                swipeLabel.text = "Swipe Right to see New Flashcards"
            }
        }else if (flashcardsIndex>=conceptNames.count) {
            swipeLabel.text = "Swipe Left to see New Flashcards"
        }else{
            swipeLabel.text = "Swipe Right/Left to see New Flashcards"
        }
    }
    @IBAction func simulateSwipeRight(_ sender: Any) {
        swipeRight()
    }
    
    @IBAction func simulateSwipeLeft(_ sender: Any) {
        swipeLeft()
    }
}
