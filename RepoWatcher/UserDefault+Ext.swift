//
//  USerDefault+Ext.swift
//  RepoWatcher
//
//  Created by Matias Martinelli on 23/01/2024.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.co.matiasmart.RepoWatcher")!
    }
    
    static let repoKey = "repos"
}
