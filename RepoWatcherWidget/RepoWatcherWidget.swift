//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Matias Martinelli on 17/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct RepoWatcherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                HStack{
                    Circle()
                        .frame(width: 60, height: 50)
                    Text("Swift News")
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack{
                    StartLabel(value: 999, systemImageName: "star.fill")
                    StartLabel(value: 999, systemImageName: "tuningfork")
                    StartLabel(value: 999, systemImageName: "exclamationmark.triangle.fill")
                }
                .padding(.leading, 8)
            }
            
            Spacer()
            
            VStack{
                Text("99")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                
                Text("Days ago")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
        }
        
    }
}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    RepoWatcherWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

fileprivate struct StartLabel: View {
    
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label{
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}
