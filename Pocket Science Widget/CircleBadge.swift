//
//  CircleBadge.swift
//  Pocket Science
//
//  Created by Ethan Chew on 9/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import SwiftUI

struct CircleBadge: View {
    var body: some View {
        Image("Expert Badge")
            .frame(width: 75, height: 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 1))
            .shadow(radius: 30)
    }
}

struct CircleBadge_Previews: PreviewProvider {
    static var previews: some View {
        CircleBadge()
    }
}
