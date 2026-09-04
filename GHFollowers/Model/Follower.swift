//
//  followers.swift
//  GHFollowers
//
//  Created by user on 02/07/2026.
//

import Foundation

nonisolated struct Follower: Codable, Hashable, Sendable {
    var login: String
    var avatarUrl: String
}
