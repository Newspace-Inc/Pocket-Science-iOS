//
//  WidgetView.swift
//  Pocket Science
//
//  Created by Ethan Chew on 28/10/20.
//  Copyright © 2020 Ethan Chew. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    var body: some View {
        
        // Replace all green with white once done
        
        HStack(alignment: .top) {
            // Recently Opened + Frequently Opened
            VStack(alignment: .leading, spacing: 15) {
        
                // Recently Opened
                VStack(alignment: .leading, spacing: 5) {
                    Text("Recently Opened")
                        .bold()
                        .foregroundColor(.green)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 10, height: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test 1")
                                .bold()
                            Text("28 October, 12:10")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Frequently Opened
                VStack(alignment: .leading, spacing: 5) {
                    Text("Frequently Opened")
                        .bold()
                        .foregroundColor(.green)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 10, height: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test 2")
                                .bold()
                            Text("10 Pickups")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 10, height: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test 3")
                                .bold()
                            Text("5 Pickups")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
            }
            
            // Goals
            VStack(alignment: .leading, spacing: 5) {
                Text("Goals")
                    .bold()
                    .foregroundColor(.green)
                
                VStack {
                    
                    // Within your reach
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Within your Reach")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        HStack(spacing: 17) {
                            HStack {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 1")
                                        .bold()
                                    Text("1 more flashcard")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 2")
                                        .bold()
                                    Text("Open app 2 times")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                            }
                        }
                    }
                    // Unattained Awards
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Unattained Awards")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        HStack(spacing: 17) {
                            HStack {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 1")
                                        .bold()
                                    Text("1 more flashcard")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 2")
                                        .bold()
                                    Text("Open app 2 times")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        HStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color.blue)
                                .frame(width: 10, height: 18)
                            Text("3 more awards unattained")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
