//
//  GitHubAPI.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

enum GitHubPeriod {
    case lastMonth
    case lastWeek
    case lastDay
}

protocol GitHubAPI {
    func getTrendingRepositories(created in: GitHubPeriod)
}
