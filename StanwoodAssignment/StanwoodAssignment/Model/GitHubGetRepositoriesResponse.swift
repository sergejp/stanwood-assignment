//
//  GitHubGetRepositoriesResponse.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation
import StanwoodCore

/*
 * Data structure in the API documentation:
 * https://developer.github.com/v3/search/#search-repositories
 */

typealias GitHubRepository = GitHubGetRepositoriesResponse.GitHubRepository

struct GitHubGetRepositoriesResponse: Codable {
    let incompleteResults: Bool
    let items: [GitHubRepository]
    
    private enum CodingKeys: String, CodingKey {
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
    
    struct GitHubRepository: Typeable, Codable {
        static func == (lhs: GitHubGetRepositoriesResponse.GitHubRepository, rhs: GitHubGetRepositoriesResponse.GitHubRepository) -> Bool {
            return lhs.id == rhs.id
        }
        
        let id: Int
        let name: String
        let fullName: String
        let owner: GitHubRepositoryOwner
        let description: String?
        let stargazersCount: Int
        let language: String?
        let forksCount: Int
        let createdAt: Date
        let htmlURL: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case fullName = "full_name"
            case owner = "owner"
            case description = "description"
            case stargazersCount = "stargazers_count"
            case language = "language"
            case forksCount = "forks_count"
            case createdAt = "created_at"
            case htmlURL = "html_url"
        }
        
        struct GitHubRepositoryOwner: Codable {
            
            let id: Int
            let login: String
            let avatarUrl: String
            let url: String
            
            private enum CodingKeys: String, CodingKey {
                case id = "id"
                case login = "login"
                case avatarUrl = "avatar_url"
                case url = "url"
            }
            
        }
        
    }
}
