//
//  HomeView.swift
//  PocketScience
//
//  Created by Ethan Chew on 13/9/21.
//

import SwiftUI

struct HomeView: View {
    // Temp Variables
    let points = 0
    let lowerPrimaryChapters = 5
    let upperPrimaryChapters = 5
    let user = "User"
    let recentlyViewed:String = "hello"
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                //Top part
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pocket Science")
                            .font(.title)
                            .bold()
                        Text("Hello, " + user)
                            .bold()
                        
                    }
                    .padding()
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )

                    Text("Points: " + String(points))
                        .padding()
                        .frame(
                            minWidth: 0,
                            maxWidth: 120,
                            alignment: .topTrailing
                        )
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: geometry.size.height*0.4,
                    alignment: .center
                )
                background(Color(red: 139/255, green: 132/255, blue: 236/255))
                
                // Level Buttons
                HStack {
                    //Lower Primary Button
                    Button(action: {loadLowerPrimary()}, label: {
                        VStack{
                            Text("Lower Primary")
                                .bold()
                                .font(.title2)
                            Text(String(lowerPrimaryChapters)+" Chapters")
                                .bold()
                            Image("Lower Primary Icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }.frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .top
                        )
                        .padding(10)
                    })
                    .frame(
                        minWidth: 0,
                        maxWidth: geometry.size.width/2,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .background(Color(red: 117/255, green: 170/255, blue: 231/255))
                    .cornerRadius(20)
                    
                    //Upper Primary Button
                    Button(action: {loadUpperPrimary()}, label: {
                        VStack{
                            Text("Upper Primary")
                                .bold()
                                .font(.title2)
                                .padding()
                            Text(String(upperPrimaryChapters) + " Chapters")
                                .bold()
                            Image("Upper Primary Icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .top
                        )
                        .padding(10)
                    })
                    .frame(
                        minWidth: 0,
                        maxWidth: geometry.size.width/2,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .background(Color(red: 82/255, green: 147/255, blue: 224/255))
                    .cornerRadius(20)
                    
                    
                }
                .padding(5)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: geometry.size.height*0.7,
                    alignment: .center
                )
                
                // Recently Opened
                VStack(alignment: .leading){
                    Text("Recently Opened")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.black)
                    Text(recentlyViewed ?? "none recently").foregroundColor(.black)
                    
                    
                }
                .padding(.leading,5)
                .frame(
                    minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                    maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                    alignment: .leading
                )
            }
        }
        .ignoresSafeArea().aspectRatio(contentMode: .fit).frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .foregroundColor(.white)
        .onAppear{
            viewDidLoad()
        }
    }
    
    // Functions
    func loadJson(forFilename fileName: String) -> NSDictionary? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                    
                    return dictionary
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        
        return nil
    }
    
    func viewDidLoad(){
        if (UserDefaults.standard.object(forKey: "mainData") != nil){
            //data loaded
            print("Data Already Loaded")
        } else {
            let json = loadJson(forFilename: "maindata")
            UserDefaults.standard.set(json, forKey: "mainData")
            print("Loaded Main Data")
        }
        
    }
    func loadUpperPrimary(){
        
    }
    func loadLowerPrimary(){
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
