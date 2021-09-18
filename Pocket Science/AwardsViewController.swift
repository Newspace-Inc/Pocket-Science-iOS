//
//  AwardsViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class CollectionViewCell: UICollectionViewCell {
    
    let badgeNameArr = ["Beginner","Expert","Maestro","Brainy","Perfectionist","Quintessential","Bookworm","Diligent Ant","Industrious Bee","Normal Member","Regular Member","Frequent member","Streaker Bronze","Streaker Silver","Streaker Gold"]
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var badgeDescription: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    func config(with rowIndex:Int) {
        var data:[String:[String]] = [:]
        var earnedAwards:Array<Int> = []
        
        if let data1 = userDefaults.object(forKey: "Badge Data") as? [String:[String]] {
            data = data1
        }
        
        if let awards = userDefaults.object(forKey: "Earned Awards") as? [Int] {
            earnedAwards = awards
            print(earnedAwards)
        }
        
        var badgeData = [""]
        
        if let badgeData1 = data[badgeNameArr[rowIndex]] {
            badgeData = badgeData1
        }
        let currentBadgeName = badgeNameArr[rowIndex]
        let earnedImageName = badgeData[2]
        let notEarnedImageName = badgeData[1]
        
        badgeDescription.text = badgeData[0]
        badgeName.text = currentBadgeName
        
        if (earnedAwards.count > 0) {
            for i in 0...earnedAwards.count - 1 {
                print(earnedAwards[i],rowIndex)
                if (earnedAwards[i] == rowIndex) {
                    badgeImageView.image = UIImage(named: earnedImageName + ".img")
                } else {
                    badgeImageView.image = UIImage(named: notEarnedImageName + ".img")
                }
            }
        }
    }
}

class AwardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!
    
    // Variables/Arrays
    var tierRequirment = [100, 500, 1000, 5000]
    var awardRequirment = [""]
    var userPoints = 0
    var tierRewards = [""]
    var userTier = ""
    var earnedAwards = [""]
    var quizAttempts = 0
    var data:[String:[String]] = [:]
    
    // UI Elements
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func getData() {
        
        // Collect Data
        let worksheetName = "Sheet1"
        
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
                    
                    userDefaults.set(data, forKey: "Badge Data")
                }
                
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if (Int(userPoints) <= tierRequirment[0]) {
            userTier = "Bronze"
        } else if (Int(userPoints) <= tierRequirment[1]) {
            userTier = "Silver"
        } else if (Int(userPoints) <= tierRequirment[2]) {
            userTier = "Gold"
        } else if (Int(userPoints) >= tierRequirment[3]) {
            userTier = "Diamond"
        }
        
        if let attemptCount:Int = userDefaults.integer(forKey: "Quiz Attempts") as? Int {
            quizAttempts = attemptCount
        }
        
        if (userTier != "") {
            userDefaults.set(userTier, forKey: "User Tier")
        }
        
        if (userPoints != 0) {
            userDefaults.set(userPoints, forKey: "User Points")
        }
        
        if let userPointsGrab:Int = userDefaults.integer(forKey: "User Points") as? Int {
            userPoints = userPointsGrab
        }
        
        if let rank = userDefaults.string(forKey: "User Tier") {
            userTier = rank
        } else {
            userTier = "NIL"
        }
        
        // Set Clip to Bounds
        badgesLabel.clipsToBounds = true
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        badgesLabel.layer.cornerRadius = 20
        uiBG.layer.cornerRadius = 20
        
        getData()
        collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell=UICollectionViewCell()
        
        if let badgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell {
            badgeCell.config(with: indexPath.row)
            
            cell = badgeCell
        }
        
        return cell
    }
}
