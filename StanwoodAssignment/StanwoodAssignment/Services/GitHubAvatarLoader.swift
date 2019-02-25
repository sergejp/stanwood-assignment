//
//  GitHubAvatarLoader.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit

protocol GitHubAvatarLoader {
    func loadOwnerAvatar(for gitHubRepository: GitHubRepository, completion: @escaping (UIImage) -> Void)
}
