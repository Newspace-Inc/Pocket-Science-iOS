//
//  ViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 31/3/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX
import MotionToastView
import SwiftDate

class ViewController: UIViewController, dataFromSettings {
        
    // Variables
    var lastOpenedData:[String] = []
    var userPoints:Int = 0
    var primaryLevel:String = LessonsViewController().primaryLevel
    var storedUserName:String = ""
    var storedUserAge = ""
    var userSchool:String = ""
    var userRank = ""
    var welcomeMessageShown:Bool = false
    var numOfTimesAppWasOpened = 0
    var earnedAwards:Array<String> = []
    let date = Date()
    var newDate = ""
    var dailyStreak = 0
    var earnedImage = ["Beginner Badge", "Bookworm Badge", "Brainy Badge", "Diligent Ant Badge", "Expert Badge", "Frequent Member Badge", "Industrious Bee Badge", "Maestro Badge", "Normal Member Badge", "Perfectionist Badge", "Regular Member Badge","Star Collector Badge","Streaker Bronze Badge","Streaker Gold Badge", "Streaker Silver Badge"]
    var isShownEB = false
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    
    
    // Buttons and Labels
    @IBOutlet weak var recentlyOpenedBtn: UIButton!
    @IBOutlet weak var upperPrimaryBtn: UIButton!
    @IBOutlet weak var lowerPrimaryBtn: UIButton!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dismissWelcomeMessage: UIButton!
    @IBOutlet weak var lastOpenedDateLabel: UILabel!
    @IBOutlet weak var dismissEarnedAward: UIButton!
    
    // Earned Award View
    @IBOutlet weak var awardImgView: UIImageView!
    @IBOutlet weak var awardName: UILabel!
    @IBOutlet weak var awardDiscrip: UILabel!
    
    // Views
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var earnedAwardView: UIView!
    
    // Background Padding
    @IBOutlet weak var bgPad: UILabel!
    
    func passDataBack(settingsUserName: String, settingsUserAge: String) {
        storedUserName = settingsUserName
        storedUserAge = settingsUserAge
    }
    
    func checkRecentlyOpened() {
        if (lastOpenedData == []) {
            return
        } else if (lastOpenedData[1] == "Lower Primary") {
            topicLabel.text = "5 Chapters"
            recentlyOpenedBtn.backgroundColor = UIColor(red: 117/255, green: 170/255, blue: 230/255, alpha: 1.0)
            
        } else if (lastOpenedData[1] == "Upper Primary") {
            topicLabel.text = "4 Chapters"
            recentlyOpenedBtn.backgroundColor = UIColor(red: 86/255, green: 146/255, blue: 229/255, alpha: 1.0)
        }
        lvlLabel.text = "\(lastOpenedData[1])"
        lastOpenedDateLabel.text = lastOpenedData[0]
        lvlLabel.alpha = 1
        topicLabel.alpha = 1
        lastOpenedDateLabel.alpha = 1
        recentlyOpenedBtn.setTitle("", for: .normal)
    }
    
    func removeDuplicates<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func showNewAwardView(award: String) {
        earnedAwardView.isHidden = false
        awardName.text = award
        
    }
    
    func dailyStreakCheck() {
        let currentDate = Date()
        var lastLoginDate:Date
        
        if let lastLogin = userDefaults.object(forKey: "Last Login Date") as? Date {
            lastLoginDate = lastLogin
        } else {
            return
        }
        
        if let streak:Int = userDefaults.integer(forKey: "Daily Streak") as? Int {
            dailyStreak = streak
        } else {
            dailyStreak = 0
        }
                
        if (currentDate.compare(.isToday) && lastLoginDate.compare(.isYesterday)) {
            dailyStreak += 1
            lastLoginDate = currentDate
            userDefaults.set(dailyStreak, forKey: "Daily Streak")
            userDefaults.set(lastLoginDate, forKey: "Last Login Date")
        } else if (currentDate.compare(.isToday) && lastLoginDate.compare(.isToday)) {
            lastLoginDate = currentDate
            userDefaults.set(dailyStreak, forKey: "Daily Streak")
            userDefaults.set(lastLoginDate, forKey: "Last Login Date")
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newDate = date.toFormat("dd MMM yyyy',' HH:mm")
        
        // Get User Points
        if let grabLastOpened:[String] = userDefaults.object(forKey: "Recently Opened Data") as? Array<String> {
            lastOpenedData = grabLastOpened
        }
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int{
            userPoints = userPointsGrab
        }
        
        if let userName = userDefaults.string(forKey: "Username") {
            userNameLabel.text = "\(userName)"
            storedUserName = "\(userName)"
        } else {
            userNameLabel.text = "Hello, User"
            storedUserName = "User"
        }
        
        if let userAge = userDefaults.string(forKey: "Userage") {
            storedUserAge = "\(userAge)"
        } else {
            storedUserAge = "NIL"
        }
        
        if let rank = userDefaults.string(forKey: "User Rank") {
            userRank = rank
        }
        
        if let userBadges = userDefaults.object(forKey: "Earned Awards") as? Array<String> {
            earnedAwards = userBadges
        }
                
        // Set Clip to Bounds
        bgPad.clipsToBounds = true
        welcomeView.clipsToBounds = true
        dismissWelcomeMessage.clipsToBounds = true
        earnedAwardView.clipsToBounds = true
        dismissEarnedAward.clipsToBounds = true
        
        // Curved Edges
        recentlyOpenedBtn.layer.cornerRadius = 20
        upperPrimaryBtn.layer.cornerRadius = 20
        lowerPrimaryBtn.layer.cornerRadius = 20
        bgPad.layer.cornerRadius = 20
        welcomeView.layer.cornerRadius = 20
        dismissWelcomeMessage.layer.cornerRadius = 10
        earnedAwardView.layer.cornerRadius = 20
        dismissEarnedAward.layer.cornerRadius = 10
                        
        // Change Label Text to Data
        pointLabel.text = "\(userPoints) Points"
                
        if let numOfTimes:Int = userDefaults.integer(forKey: "Number Of Times App Opened") as? Int {
            numOfTimesAppWasOpened = numOfTimes
        }
                
        // Check if Welcome Message was shown before
        if let welcomeMessageShownBefore:Bool = userDefaults.bool(forKey: "Welcome Message") as? Bool {
            welcomeMessageShown = welcomeMessageShownBefore
        }

        numOfTimesAppWasOpened += 1
        userDefaults.set(numOfTimesAppWasOpened, forKey: "Number Of Times App Opened")
        
        print("Number of Times App was Opened: \(numOfTimesAppWasOpened)")
        
        dailyStreakCheck()
        checkRecentlyOpened()
        
        // Check for New Badges
        let newBadges = checkBadges()
        if (newBadges.didNewBadges) {
            var badgeData:[String:[String]]
            if let getData = userDefaults.object(forKey: "Badge Data") as? [String:[String]] {
                badgeData = getData
            } else {
                print("Reloading Badge Data...")
                badgeData = getBadges()
            }
            
            if newBadges.newBadges.count > 1 {
                let newBadge = newBadges.newBadges[0].replacingOccurrences(of: " Badge", with: "")
                awardImgView.image = UIImage(named: badgeData[newBadge]![2] + ".img")
                awardName.text = newBadge
                awardDiscrip.text = badgeData[newBadge]![0]
            } else {
                let newBadge = newBadges.newBadges[0].replacingOccurrences(of: " Badge", with: "")
                awardImgView.image = UIImage(named: badgeData[newBadge]![2] + ".img")
                awardName.text = newBadge
                awardDiscrip.text = badgeData[newBadge]![0]
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newDate = date.toFormat("dd MMM yyyy',' HH:mm")
        
        // Get User Points
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int{
            userPoints = userPointsGrab
        }
        
        if let userName = userDefaults.string(forKey: "Username") {
            userNameLabel.text = "Hello, \(userName)"
            storedUserName = "\(userName)"
        } else {
            userNameLabel.text = "Hello, User"
            storedUserName = "User"
        }
        
        if let userAge = userDefaults.string(forKey: "Userage") {
            storedUserAge = "\(userAge)"
        } else {
            storedUserAge = "NIL"
        }
        
        if let rank = userDefaults.string(forKey: "User Rank") {
            userRank = rank
        }
        
        if let userBadges = userDefaults.object(forKey: "Earned Awards") as? Array<String> {
            earnedAwards = userBadges
        }

        pointLabel.text = "\(userPoints) Points"
    }
    
    // Button Config
    @IBAction func goToRecentlyOpened(_ sender: Any) {
        performSegue(withIdentifier: "lessons", sender: nil)
    }
    
    @IBAction func dismissWelcomeMessage(_ sender: Any) {
        welcomeMessageShown = true
        userDefaults.set(welcomeMessageShown, forKey: "Welcome Message")
        welcomeView.isHidden = true
    }
    
    @IBAction func dismissEarnedAward(_ sender: Any) {
        isShownEB = true
        welcomeView.isHidden = true
    }
    
    @IBAction func goToLowerPrimary(_ sender: Any) {
        lastOpenedData = [] // Clear Array
        lastOpenedData.append(newDate)
        lastOpenedData.append("Lower Primary")
        performSegue(withIdentifier: "lessons", sender: nil)
        
        userDefaults.set(lastOpenedData, forKey: "Recently Opened Data")

        checkRecentlyOpened()
    }
    
    @IBAction func goToUpperPrimary(_ sender: Any) {
        lastOpenedData = [] // Clear Array
        lastOpenedData.append(newDate)
        lastOpenedData.append("Upper Primary")
        performSegue(withIdentifier: "lessons", sender: nil)
        
        userDefaults.set(lastOpenedData, forKey: "Recently Opened Data")
        
        checkRecentlyOpened()
    }
}

func getBadges() -> [String:[String]] {
    
    // Collect Data
    let worksheetName = "Sheet1"
    var data:[String:[String]] = [:]
    
    do {
        let filepath = Bundle.main.path(forResource: "Badges", ofType: "xlsx")!
        
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
            let numOfBadges = 15
            
            for i in 1...numOfBadges {
                var parseBadges = worksheet.cells(atRows: [UInt(i)])
                    .compactMap { $0.stringValue(sharedStrings) }
                let badgeName = parseBadges[0]
                parseBadges.remove(at: 0)
                
                data[badgeName] = parseBadges
            }
            
        }
    } catch {
        fatalError("\(error.localizedDescription)")
    }
    return data
}
