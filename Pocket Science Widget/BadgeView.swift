//
//  BadgeView.swift
//  Pocket Science
//
//  Created by Ethan Chew on 9/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import SwiftUI

extension Color {
    static let badgeViewColour = Color("BadgeView Colour")
}

struct BadgeView: View {
    var body: some View {
        
        let userDefaults = UserDefaults.standard
        let userPoints = userDefaults.integer(forKey: "User Points")
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("User Rank: ")
                    .padding(1)
                Text("Daily Streak: ")
                    .padding(1)
                Text("Points: ")
            }
            
            
            VStack(alignment: .leading) {
                Text("Gold")
                    .padding(1)
                Text("1 Day")
                    .padding(1)
                Text("\(userPoints)")
            }
            .padding(1)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                CircleBadge()
            }
            .padding(3)
            
        }
        .padding(20)
        .background(Color.badgeViewColour)
        .cornerRadius(20)
        
    }
}


struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
