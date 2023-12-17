//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Matias Martinelli on 17/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        //When we are using a async network call we need to get into a async context
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                let repo = try await NetworkManager.shared.getRepo(atUrl: repoURL.googleSignIn)
                let entry = RepoEntry(date: .now, repo: repo)
                //Reload policy
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    
}

struct RepoWatcherWidgetEntryView : View {
    var entry: RepoEntry
    //We create the formatter here because its a memory consumer task and we don't want to run it every time we call the function calculateDatSinceLastActivity
    let formatter = ISO8601DateFormatter() //This formatter let us work with string dates
    var daysSinceLastActivity: Int {
        calculateDatSinceLastActivity(from: entry.repo.pushedAt)
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                HStack{
                    Circle()
                        .frame(width: 60, height: 50)
                    Text(entry.repo.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack{
                    StartLabel(value: entry.repo.watchers, systemImageName: "star.fill")
                    StartLabel(value: entry.repo.forks, systemImageName: "tuningfork")
                    StartLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                }
                .padding(.leading, 8)
            }
            
            Spacer()
            
            VStack{
                Text("\(daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivity > 50 ? .pink : .green)
                
                Text("Days ago")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } 
            
        }
        
    }
    
    //Function to calculate how many day past since the last update
    func calculateDatSinceLastActivity(from dateString: String) -> Int {
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        //calcutaion of days since last Activity to now
        let daySinceLastActity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        return daySinceLastActity
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
    RepoEntry(date: .now, repo: Repository.placeholder)
    RepoEntry(date: .now, repo: Repository.placeholder)
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
