//
//  ContentView.swift
//  PocketScience
//
//  Created by Ethan Chew on 13/9/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            AwardsView()
                .tabItem {
                    Label("Awards", systemImage: "rosette")
                }
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "star.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
