//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Matias Martinelli on 17/12/2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atUrl urlString: String) async throws -> Repository {
        
        //We make sure that we have a valid URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidRepoURL
        }
        
        // If this succeed we make sure that we have a good data and response
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //We make sure that the response its valid
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // If the decode it's successful we return a Repository
        do {
            return try decoder.decode(Repository.self, from: data)
        } catch {
            throw NetworkError.invalidRepoData
        }

    }
}

enum NetworkError: Error {
    case invalidRepoURL
    case invalidResponse
    case invalidRepoData
}

enum repoURL {
    static let swiftNews = "https://api.github.com/repos/SAllen0400/swift-news"
    static let publish = "https://api.github.com/repos/joshundell/publish"
    static let googleSignIn = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
 
