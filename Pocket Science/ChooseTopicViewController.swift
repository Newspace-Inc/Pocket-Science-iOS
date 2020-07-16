//
//  ChooseTopicViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 19/5/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class ChooseTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Variables
    var recentlyOpenedLevel:String = ""
    var userPoints:Int = 0
    var selectedSubtopic:String = ""
    var primaryLevel:String = ""
    var userName = ""
    let lowerPriTopics = ["Cycles", "Systems", "Diversity", "Interactions", "Energy"]
    let upperPriTopics = ["Cycles", "Systems", "Interactions", "Energy"]
    let lowerPriTopicsAmt = ["", "", "", "", ""]
    let upperPriTopicsAmt = ["", "", "", ""]
    
    let userDefaults = UserDefaults.standard
    
    // UI Elements
    @IBOutlet weak var mainUPLabel: UILabel!
    @IBOutlet weak var secUPLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiBG: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // Save data into user defaults
        if let recentlyOpened = userDefaults.string(forKey: "Recently Opened") {
            primaryLevel = recentlyOpened
        }
        
        // Set labels
        mainUPLabel.text = "\(primaryLevel)"
        secUPLabel.text =  "The \(primaryLevel) Syllabus"
        
        // Grab from User Defaults
        if primaryLevel != "" {
            userDefaults.set(primaryLevel, forKey: "Recently Opened")
        }
        
        // Config UI Background
        uiBG.clipsToBounds = true
        uiBG.layer.cornerRadius = 20
    }
    
    // Set data into Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (primaryLevel == "Lower Primary") {
            return lowerPriTopics.count
        } else {
            return upperPriTopics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.layer.cornerRadius = 5
        
        if (primaryLevel == "Lower Primary") {
            cell.textLabel!.text = "\(lowerPriTopics[indexPath.row])"
            cell.detailTextLabel!.text = "\(lowerPriTopicsAmt[indexPath.row])"
        } else {
            cell.textLabel!.text = "\(upperPriTopics[indexPath.row])"
            cell.detailTextLabel!.text = "\(upperPriTopicsAmt[indexPath.row])"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = LessonsViewController()
        if (primaryLevel == "Lower Primary") {
            destinationVC.selectedLesson = lowerPriTopics[indexPath.row]
            
            if (lowerPriTopics[indexPath.row] != "") {
                userDefaults.set(lowerPriTopics[indexPath.row], forKey: "Opened Lesson")
            }
        } else {
            destinationVC.selectedLesson = upperPriTopics[indexPath.row]
            
            if (upperPriTopics[indexPath.row] != "") {
                userDefaults.set(upperPriTopics[indexPath.row], forKey: "Opened Lesson")
            }
        }
        
        performSegue(withIdentifier: "lessons", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
