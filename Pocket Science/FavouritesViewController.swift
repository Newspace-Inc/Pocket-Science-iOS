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
    
    let userDefaults = UserDefaults(suiteName: "group.pocketscience")!

    // Labels and Buttons
    @IBOutlet weak var uiBG: UILabel!
    @IBOutlet weak var removeAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavLabel: UILabel!
    
    func deleteDataAlert() {

        // Create Alert
        var dialogMessage = UIAlertController(title: "Delete All Favourites", message: "Are you sure you want to erase your favourited items? This action is NOT REVERSABLE.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { [self] (action) -> Void in
            favouriteFlashcards = []
            userDefaults.set(favouriteFlashcards, forKey: "Favourite Flashcard")
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            self.tableView.isHidden = true
            noFavLabel.isHidden = false
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // Cancelation code
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        if let favourited:Array<String> = userDefaults.object(forKey: "Favourite Flashcard") as? [String] {
            favouriteFlashcards = favourited
        }
        // Set Clip to Bounds
        uiBG.clipsToBounds = true
        removeAll.clipsToBounds = true
        
        // Set Corner Radius
        uiBG.layer.cornerRadius = 20
        removeAll.layer.cornerRadius = 10
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Check for Favourite Flashcards
        if (favouriteFlashcards.count == 0) {
            isFavouritesEmpty = true
        } else {
            isFavouritesEmpty = false
        }
        
        self.tableView.isHidden = false
        noFavLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        print("Data Refresh")
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFavouritesEmpty) {
            return 1
        } else {
            return favouriteFlashcards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if (isFavouritesEmpty) {
            self.tableView.isHidden = true
            noFavLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            noFavLabel.isHidden = true
            cell.textLabel?.text = "\(favouriteFlashcards[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if (!isFavouritesEmpty) {
            if favouriteFlashcards[indexPath.row] != "" {
                userDefaults.set(favouriteFlashcards[indexPath.row], forKey: "Selected Favourite Flashcard")
            }
            performSegue(withIdentifier: "favouriteFlashcards", sender: nil)
        }
    }
    @IBAction func removeAllBtn(_ sender: Any) {
        deleteDataAlert()
    }
}
