//
//  ThemeSelectorView.swift
//  PocketScience
//
//  Created by Ethan Chew on 14/9/21.
//

import SwiftUI

struct ThemeSelectorView: View {
    // Variables
    let themeColor = Color(red: 138/255, green: 132/255, blue: 229/255)

    var level = "Lower Primary"
    let lowerPriThemes = ["Cycles", "Systems", "Diversity", "Interactions", "Energy"]
    let upperPriThemes = ["Cycles", "Systems", "Interactions", "Energy"]
    
    var body: some View {
        VStack() {
            ZStack() {
                HStack() {
                    Rectangle()
                        .fill(themeColor)
                        .frame(width: .infinity, height: 180)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Pocket Science")
                        .foregroundColor(.white)
                        .font(.system(size: 30.0))
                        .fontWeight(.bold)
                    Text(level)
                        .foregroundColor(.white)
                        .font(.system(size: 22.0))
                }
                .offset(x: -70, y: -10)
            }
            .edgesIgnoringSafeArea(.top)
            
            if (level == "Lower Primary") {
                NavigationView {
                    List {
                        Text("Diversity")
                        Text("Systems")
                        Text("Cycles")
                        Text("Interactions")
                        Text("Energy")
                    }
                }
                .navigationTitle("Theme Selector")
            } else {
                NavigationView {
                    List {
                        Text("Systems")
                        Text("Cycles")
                        Text("Interactions")
                        Text("Energy")
                    }
                }
                .navigationTitle("Theme Selector")
            }
            Spacer()
        }
    }
}

struct ThemeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectorView()
    }
}
