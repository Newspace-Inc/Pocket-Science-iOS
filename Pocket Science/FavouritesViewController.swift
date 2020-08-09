//
//  FavouritesViewController.swift
//  Pocket Science
//
//  Created by Ethan Chew on 6/4/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import UIKit
import CoreXLSX

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var favouriteFlashcards:Array<String> = []
    var isFavouritesEmpty = false
    
    let userDefaults = UserDefaults.standard
    
    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favourited:Array<String> = userDefaults.object(forKey: "Favourite Flashcard") as? [String] ?? [String](){
            favouriteFlashcards = favourited
        }
        
        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        
        // Set Corner Radius
        uiBG.layer.cornerRadius = 20
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (favouriteFlashcards.count == 0) {
            isFavouritesEmpty = true
            return 1
        } else {
            return favouriteFlashcards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if (isFavouritesEmpty) {
            cell.textLabel?.text = "You have not favourited anything."
        } else {
            cell.textLabel?.text = "\(favouriteFlashcards[indexPath.row])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = FavouriteFlashcardsViewController()
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if (cell.textLabel?.text == "You have not favourited anything.") {
            return
        } else {
            if favouriteFlashcards[indexPath.row] != "" {
                userDefaults.set(favouriteFlashcards[indexPath.row], forKey: "Selected Favourite Flashcard")
            }
            performSegue(withIdentifier: "favouriteFlashcards", sender: nil)
        }
    }
}
