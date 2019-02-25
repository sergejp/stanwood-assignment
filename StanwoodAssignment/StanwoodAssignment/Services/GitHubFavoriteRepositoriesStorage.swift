//
//  GitHubFavoriteRepositoriesStorage.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

protocol GitHubFavoriteRepositoriesStorage {
    func add(_ repository: GitHubRepository)
    func remove(_ repository: GitHubRepository)
    func contains(_ repository: GitHubRepository) -> Bool
}
