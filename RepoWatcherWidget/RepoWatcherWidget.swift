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
        RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        //When we are using a async network call we need to get into a async context
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoURL.googleSignIn)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                let entry = RepoEntry(date: .now, repo: repo, bottomRepo: nil)
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
    let bottomRepo: Repository?
    
}

struct RepoWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry
    //We create the formatter here because its a memory consumer task and we don't want to run it every time we call the function calculateDatSinceLastActivity
    var body: some View {
        switch family{
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack(spacing: 36){
                RepoMediumView(repo: entry.repo)
                RepoMediumView(repo: MockData.repoTwo)
            }
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
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
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on one or two Github Repositories")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemLarge) {
    RepoWatcherWidget()
} timeline: {
    RepoEntry(
        date: .now,
        repo: MockData.repoOne,
        bottomRepo: MockData.repoTwo
    )
    RepoEntry(
        date: .now,
        repo: MockData.repoOne,
        bottomRepo: MockData.repoTwo
    )
}


