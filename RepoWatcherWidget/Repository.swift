//
//  Repository.swift
//  RepoWatcher
//
//  Created by Matias Martinelli on 17/12/2023.
//

import Foundation
import SwiftUI

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    // We create a placeholder with info so we can show it when oreviewing the widgter
    static let placeholder = Repository(name: "Your Repo",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 65,
                                        watchers: 123,
                                        openIssues: 55,
                                        pushedAt: "2022-12-01T14:31:24Z")
}



struct Owner: Decodable {
    let avatarUrl: String
}
