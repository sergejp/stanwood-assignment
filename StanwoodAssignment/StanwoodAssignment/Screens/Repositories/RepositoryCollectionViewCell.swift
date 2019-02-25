//
//  RepositoryCollectionViewCell.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation
import StanwoodCore

final class RepositoryCollectionViewCell: Stanwood.AutoSizeableCell, Fillable {
    
    @IBOutlet private weak var avatar: AvatarImageView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var descriptionTitle: UILabel!
    @IBOutlet private weak var star: UIButton!
    @IBOutlet private weak var starCount: UILabel!
    @IBOutlet private weak var detailIndicator: UIImageView!
    
    private let favorites: GitHubFavoriteRepositoriesStorage = ServiceLocator.shared.get()
    private let avatarLoader: GitHubAvatarLoader = ServiceLocator.shared.get()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        star.addTarget(self, action: #selector(onStarTap), for: .touchUpInside)
    }
    
    @objc private func onStarTap() {
        
    }
    
    override func prepare() {
        avatar.title = ""
        avatar.image = nil
        fullName.text = nil
        descriptionTitle.text = nil
        star.isSelected = false
        starCount.text = nil
    }
    
    func fill(with type: Type?) {
        guard let item = type as? GitHubRepository else { return }

        avatar.title = item.name.first
        avatarLoader.loadOwnerAvatar(for: item) { [weak self] avatarImage in
            main {
                self?.avatar.image = avatarImage
            }
        }
        fullName.text = item.fullName
        descriptionTitle.text = item.description ?? NSLocalizedString("Repository owner didn't provide description", comment: "")
        star.isSelected = favorites.contains(item) ? true : false
        starCount.text = String(item.stargazersCount)
    }
}
