//
//  PocketScienceApp.swift
//  PocketScience
//
//  Created by Ethan Chew on 13/9/21.
//

import SwiftUI

@main
struct PocketScienceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
