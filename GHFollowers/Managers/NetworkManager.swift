//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by user on 02/07/2026.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    // ---------------------------------------------------------
    // MARK: - Concept: Async / Await
    // ---------------------------------------------------------
    // We replaced the `@escaping (Result...) -> Void` closure with `async throws -> [Follower]`.
    // This tells the compiler: "This function takes time (async), and it might fail (throws).
    // If it succeeds, it will just hand you back an array of Followers directly!"
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        // Use the modern async URLSession method. No more closures!
        // We 'await' the result, which pauses this function until the internet responds.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

}
