//
//  MockData.swift
//  RepoWatcher
//
//  Created by Matias Martinelli on 24/12/2023.
//

import Foundation

struct MockData {
    
    static let repoOne = Repository(
        name: "Repository 1",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 65,
        watchers: 123,
        openIssues: 55,
        pushedAt: "2023-12-01T14:31:24Z",
        avatarData: Data(),
        contributors: [Contributor( login: "Sean Allen", avatarUrl: "", contributions: 42, avatarData: Data()),
                       Contributor( login: "Michel Jordan", avatarUrl: "", contributions: 23, avatarData: Data()),
                       Contributor( login: "Matias Martinelli", avatarUrl: "", contributions: 71, avatarData: Data()),
                       Contributor( login: "Lebron James", avatarUrl: "", contributions: 11, avatarData: Data())])
    
    static let repoOneV2 = Repository(
        name: "Repository 1",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 165,
        watchers: 223,
        openIssues: 100,
        pushedAt: "2024-01-01T14:31:24Z",
        avatarData: Data(),
        contributors: [Contributor( login: "Sean Allen", avatarUrl: "", contributions: 144, avatarData: Data()),
                       Contributor( login: "Michel Jordan", avatarUrl: "", contributions: 50, avatarData: Data()),
                       Contributor( login: "Matias Martinelli", avatarUrl: "", contributions: 77, avatarData: Data()),
                       Contributor( login: "Lebron James", avatarUrl: "", contributions: 16, avatarData: Data())])
    
    static let repoTwo = Repository(name: "Repository 2",
                                  owner: Owner(avatarUrl: ""),
                                  hasIssues: false,
                                  forks: 135,
                                  watchers: 996,
                                  openIssues: 55,
                                  pushedAt: "2022-01-01T14:31:24Z",
                                  avatarData: Data())
}
