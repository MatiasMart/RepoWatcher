//
//  ContribuitorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Matias Martinelli on 24/12/2023.
//

import SwiftUI
import WidgetKit

struct SingleRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {
        Task {
            
            do {
                
                let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
                
                // Get Repo
                let repoToShow = repoURL.googleSignIn
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                // Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                // Filter to just 4
                var topFour = Array(contributors.prefix(4))
                
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
                
                // Create entry & Timeline
                
                
                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct SingleEntryView : View {
    var entry: SingleRepoEntry
    
    var body: some View {
        VStack{
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
                .scenePadding(.top)
        }
        .containerBackground(for: .widget) { }
    }
}

struct SingleRepoWidget: Widget {
    let kind: String = "SingleRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                SingleEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SingleEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("SingleRepo")
        .description("Keep track of a single repository's top contributors")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemLarge) {
    SingleRepoWidget()
} timeline: {
    SingleRepoEntry(
        date: .now, repo: MockData.repoOne
    )
    SingleRepoEntry(
        date: .now, repo: MockData.repoOneV2
    )
}


