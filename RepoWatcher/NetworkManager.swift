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
            let codigData = try decoder.decode(Repository.CodingData.self, from: data)
            return codigData.repo
        } catch {
            throw NetworkError.invalidRepoData
        }
    }
    
    func getContributors(atUrl urlString: String) async throws -> [Contributor] {
        
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
            let codingData = try decoder.decode([Contributor.CodingData].self, from: data)
            let contributors = codingData.map { $0.contributor }
            return contributors
        } catch {
            throw NetworkError.invalidRepoData
        }

    }
    
    
    
    func downloadImageData (from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
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
    static let ObjC = "https://api.github.com/repos/vlondon/awesome-swiftui"
    static let googleSignIn = "https://api.github.com/repos/google/GoogleSignIn-iOS"
    static let vsouza = "https://api.github.com/repos/vsouza/awesome-ios"
    static let learning = "https://api.github.com/repos/eleev/ios-learning-materials"
    static let OpenSource = "https://api.github.com/repos/dkhamsing/open-source-ios-apps"
    static let contributorsURL = "https://api.github.com/repos/SAllen0400/swift-news/subscribers"
}

 
