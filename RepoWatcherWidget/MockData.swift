//
//  MockData.swift
//  RepoWatcher
//
//  Created by Matias Martinelli on 24/12/2023.
//

import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repository 1",
                                  owner: Owner(avatarUrl: ""),
                                  hasIssues: true,
                                  forks: 65,
                                  watchers: 123,
                                  openIssues: 55,
                                  pushedAt: "2023-12-01T14:31:24Z",
                                  avatarData: Data())
    
    static let repoTwo = Repository(name: "Repository 2",
                                  owner: Owner(avatarUrl: ""),
                                  hasIssues: false,
                                  forks: 135,
                                  watchers: 996,
                                  openIssues: 55,
                                  pushedAt: "2022-01-01T14:31:24Z",
                                  avatarData: Data())
}
