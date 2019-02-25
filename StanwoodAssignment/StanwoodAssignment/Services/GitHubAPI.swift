//
//  GitHubAPI.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

typealias GitHubGetRepositoryResult = (Result<[GitHubRepository]>) -> Void

protocol GitHubAPI {
    func getRepositories(createdIn period: GitHubPeriod, sortBy sort: GitHubSortType, orderBy order: GitHubSortOrder, completion: @escaping GitHubGetRepositoryResult)
}

enum GitHubPeriod {
    case lastMonth
    case lastWeek
    case lastDay
}

enum GitHubSortType {
    case stars
}

enum GitHubSortOrder {
    case ascending
    case descending
}
