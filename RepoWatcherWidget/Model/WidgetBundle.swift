//
//  WidgetBundle.swift
//  RepoWatcherWidgetExtension
//
//  Created by Matias Martinelli on 24/12/2023.
//

import Foundation
import SwiftUI
import WidgetKit

@main
struct RepoWatcherWidget: WidgetBundle {
    var body: some Widget {
        CompactRepoWidget()
        SingleRepoWidget()
    }
}
