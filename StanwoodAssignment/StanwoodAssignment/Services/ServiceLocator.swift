//
//  ServiceLocator.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/24/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    private var registry = [String: Any]()
    
    private init() {}
    
    private func get<T>(_ service: T.Type) -> T? {
        let key = String(describing: service)
        return registry[key] as? T
    }
    
    private func set<T>(_ service: T) {
        let serviceType = type(of: service)
        let key = String(describing: serviceType)
        registry[key] = service
    }
    
    func get() -> GitHubAPI {
        if let service = get(GitHubAPIImp.self) {
            return service
        }
        let service = GitHubAPIImp()
        set(service)
        return service
    }
    
    func get() -> GitHubFavoriteRepositoriesStorage {
        if let service = get(GitHubFavoriteRepositoriesStorageImp.self) {
            return service
        }
        let service = GitHubFavoriteRepositoriesStorageImp()
        set(service)
        return service
    }
    
    func get() -> GitHubAvatarLoader {
        if let service = get(GitHubAvatarLoaderImp.self) {
            return service
        }
        let service = GitHubAvatarLoaderImp()
        set(service)
        return service
    }
    
}
