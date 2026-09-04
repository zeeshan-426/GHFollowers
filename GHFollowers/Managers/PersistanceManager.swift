//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by user on 18/07/2026.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favorites = "favorites"
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    // ---------------------------------------------------------
    // MARK: - Save Favorites
    // ---------------------------------------------------------
    // This function does the exact opposite of retrieveFavorites.
    // It takes our [Follower] array and translates it BACK into raw Data
    // using a JSONEncoder, so we can save it to UserDefaults.
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            // Try to encode the array of followers into Data
            let encodedFavorites = try encoder.encode(favorites)
            
            // If successful, save that Data to UserDefaults using our exact key
            defaults.set(encodedFavorites, forKey: keys.favorites)
            
            // Return nil because there was NO error! (Success)
            return nil
        } catch {
            // If encoding fails, return our custom error
            return .unableToFavorite
        }
    }
    
    // ---------------------------------------------------------
    // MARK: - Update Favorites (Add or Remove)
    // ---------------------------------------------------------
    // This is the main function our app will actually call.
    // It first retrieves the current list, modifies it (adds or removes),
    // and then saves the entire list back to UserDefaults.
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        
        // 1. Get the current list of favorites first
        retrieveFavorites { result in
            switch result {
            case .success(var retrievedFavorites): // Note: 'var' so we can modify it
                
                // 2. Decide what to do based on the actionType
                switch actionType {
                case .add:
                    // Check if this user is ALREADY in the favorites list to prevent duplicates
                    guard !retrievedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites) // Early exit with our custom error!
                        return
                    }
                    
                    // If they aren't in the list, add them!
                    retrievedFavorites.append(favorite)
                    
                case .remove:
                    // Remove all followers from the array that have the same login as our target
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                // 3. Save the newly modified array back to UserDefaults!
                // Since save() returns an optional error, we just pass that error to our completion
                completed(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                // If we couldn't even retrieve the list in the first place, fail early
                completed(error)
            }
        }
    }
}
