//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Matias Martinelli on 17/12/2023.
//

import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        RepoWatcherWidget()
        RepoWatcherWidgetLiveActivity()
    }
}
