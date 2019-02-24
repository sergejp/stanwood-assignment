//
//  RepositoriesViewModel.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

final class RepositoriesViewModel {
    
    private let github: GitHubAPI
    
    init(github: GitHubAPI) {
        self.github = github
    }
    
}
