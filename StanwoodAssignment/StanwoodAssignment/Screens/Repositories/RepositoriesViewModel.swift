//
//  RepositoriesViewModel.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation
import StanwoodCore

final class RepositoriesViewModel {
    
    var repositories: [GitHubRepository]
    
    private let github: GitHubAPI
    
    init(github: GitHubAPI) {
        self.github = github
        repositories = []
    }
    
    func getRepositories(createdIn period: GitHubPeriod, sortBy sort: GitHubSortType, orderBy order: GitHubSortOrder, completion: @escaping VoidClosure) {
        github.getRepositories(createdIn: period, sortBy: sort, orderBy: order, completion: { result in
            switch result {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print(error)
            }
            
            main {
                completion()
            }
        })
    }
    
}
