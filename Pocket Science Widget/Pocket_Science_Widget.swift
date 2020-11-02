//
//  Widget.swift
//  Widget
//
//  Created by Ethan Chew on 30/9/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetEntryView : View {
    var entry: Provider.Entry
    let data = prepareData()
 
    var body: some View {
                
        // UI
        HStack(alignment: .top) {
            // Recently Opened + Frequently Opened
            VStack(alignment: .leading, spacing: 5) {
                
                // Recently Opened
                VStack(alignment: .leading, spacing: 5) {
                    Text("Recently Opened")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 5, height: 34)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.lastOpened)
                                .bold()
                                .font(.system(size: 13))
                            Text(data.lastOpenedDate)
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                    }
                }
                
                // Frequently Opened
                VStack(alignment: .leading, spacing: 5) {
                    Text("Frequently Opened")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 5, height: 34)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test 2")
                                .bold()
                                .font(.system(size: 13))
                            Text("10 Pickups")
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.blue)
                            .frame(width: 5, height: 34)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test 3")
                                .bold()
                                .font(.system(size: 13))
                            Text("5 Pickups")
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                    }
                }
                
            }
            
            // Goals
            VStack(alignment: .leading, spacing: 5) {
                Text("Goals")
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                VStack {
                    // Within your reach
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Within your Reach")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        HStack(spacing: 10) {
                            HStack {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 5, height: 34)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 1")
                                        .bold()
                                        .font(.system(size: 13))
                                    Text("1 more flashcard")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                            }
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 5, height: 34)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 2")
                                        .bold()
                                        .font(.system(size: 13))
                                    Text("Open app 2 times")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                                
                            }
                        }
                    }
                    // Unattained Awards
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Unattained Awards")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        HStack(spacing: 10) {
                            HStack {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 5, height: 34)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 1")
                                        .bold()
                                        .font(.system(size: 13))
                                    Text("1 more flashcard")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                            }
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 5, height: 34)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge 2")
                                        .bold()
                                        .font(.system(size: 13))
                                    Text("Open app 2 times")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                            }
                        }
                        HStack {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(Color.blue)
                                .frame(width: 5, height: 18)
                            Text("3 more awards unattained")
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                    }
                }
            }
        }
    }
}


@main
struct Widget1: Widget {
    let kind: String = "Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Stats")
        .description("Stats on Pocket Science")
        .supportedFamilies([.systemMedium])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
