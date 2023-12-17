//
//  RepoWatcherWidgetLiveActivity.swift
//  RepoWatcherWidget
//
//  Created by Matias Martinelli on 17/12/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RepoWatcherWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RepoWatcherWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RepoWatcherWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension RepoWatcherWidgetAttributes {
    fileprivate static var preview: RepoWatcherWidgetAttributes {
        RepoWatcherWidgetAttributes(name: "World")
    }
}

extension RepoWatcherWidgetAttributes.ContentState {
    fileprivate static var smiley: RepoWatcherWidgetAttributes.ContentState {
        RepoWatcherWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RepoWatcherWidgetAttributes.ContentState {
         RepoWatcherWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: RepoWatcherWidgetAttributes.preview) {
   RepoWatcherWidgetLiveActivity()
} contentStates: {
    RepoWatcherWidgetAttributes.ContentState.smiley
    RepoWatcherWidgetAttributes.ContentState.starEyes
}
