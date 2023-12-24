//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Matias Martinelli on 17/12/2023.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        //When we are using a async network call we need to get into a async context
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoURL.googleSignIn)
                // Get the avatar image of the repo
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                // Set the avatar data
                repo.avatarData = avatarImageData ?? Data()
                
                //Get Bottom Repo if in Large Widget
                var bottomRepo: Repository?
                if context.family == .systemLarge {
                    // Get Top Repo
                     bottomRepo = try await NetworkManager.shared.getRepo(atUrl: repoURL.swiftNews)
                    // Get the avatar image of the repo
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    // Set the avatar data
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }
                
                // Create entry & Timeline
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                //Reload policy
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
    
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoEntry
    //We create the formatter here because its a memory consumer task and we don't want to run it every time we call the function calculateDatSinceLastActivity
    var body: some View {
        switch family{
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack(spacing: 36){
                RepoMediumView(repo: entry.repo)
                if let bottomRepo = entry.bottomRepo{
                    RepoMediumView(repo: bottomRepo)
                }
            }
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                CompactRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CompactRepoEntryView(entry: entry)
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
    CompactRepoWidget()
} timeline: {
    CompactRepoEntry(
        date: .now,
        repo: MockData.repoOne,
        bottomRepo: MockData.repoTwo
    )
    CompactRepoEntry(
        date: .now,
        repo: MockData.repoOne,
        bottomRepo: MockData.repoTwo
    )
}


