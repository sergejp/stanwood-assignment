//
//  GitHubFavoriteRepositoriesStorageImp.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

final class GitHubFavoriteRepositoriesStorageImp: GitHubFavoriteRepositoriesStorage {
    
    private var list: [GitHubRepository] {
        do {
            if let encoded = UserDefaults.standard.object(forKey: storageKey) as? Data {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Array<GitHubRepository>.self, from: encoded)
                ids = Set(decoded.map({ $0.id }))
                return decoded
            }
        } catch {
            print("Decoding GitHubRepository array error: \(error)")
        }
        
        ids = []
        return []
    }
    
    private var ids = Set<Int>()
    private let storageKey = "gitHubFavoriteRepositories"
    
    func add(_ repository: GitHubRepository) {
        var repositories = list
        guard !repositories.contains(repository) else {
            return
        }
        repositories.append(repository)
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(repositories)
            UserDefaults.standard.set(encoded, forKey: storageKey)
            ids.insert(repository.id)
        } catch {
            print(error)
        }
    }
    
    func remove(_ repository: GitHubRepository) {
        var repositories = list
        repositories.removeAll { item -> Bool in
            return item == repository
        }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(repositories)
            UserDefaults.standard.set(encoded, forKey: storageKey)
            ids.remove(repository.id)
        } catch {
            print(error)
        }
    }
    
    func contains(_ repository: GitHubRepository) -> Bool {
        return ids.contains(repository.id)
    }
    
}
