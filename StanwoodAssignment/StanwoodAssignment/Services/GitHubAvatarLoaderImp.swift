//
//  GitHubAvatarLoaderImp.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit
import StanwoodCore

final class GitHubAvatarLoaderImp: GitHubAvatarLoader {

    private var cache: [String: UIImage] = [:]
    
    func loadOwnerAvatar(for gitHubRepository: GitHubRepository, completion: @escaping (UIImage) -> Void) {
        if let avatar = cache[gitHubRepository.owner.avatarUrl] {
            completion(avatar)
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: gitHubRepository.owner.avatarUrl),
                let data = try? Data(contentsOf: url),
                let avatarImage = UIImage(data: data) {
                main {
                    self?.cache[gitHubRepository.owner.avatarUrl] = avatarImage
                    completion(avatarImage)
                }
            }
        }
    }
}
