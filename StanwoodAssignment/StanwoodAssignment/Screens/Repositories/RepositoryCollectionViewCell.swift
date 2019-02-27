//
//  RepositoryCollectionViewCell.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation
import StanwoodCore

final class RepositoryCollectionViewCell: UICollectionViewCell, Fillable {
    
    @IBOutlet private weak var avatar: AvatarImageView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var descriptionTitle: UILabel!
    @IBOutlet private weak var star: UIButton!
    @IBOutlet private weak var starCount: UILabel!
    @IBOutlet private weak var detailIndicator: UIImageView!
    
    private let favorites: GitHubFavoriteRepositoriesStorage = ServiceLocator.shared.get()
    private let avatarLoader: GitHubAvatarLoader = ServiceLocator.shared.get()
    private var repository: GitHubRepository!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        star.addTarget(self, action: #selector(onStarTap), for: .touchUpInside)
    }
    
    @objc private func onStarTap() {
        if favorites.contains(repository) {
            favorites.remove(repository)
        } else {
            favorites.add(repository)
        }
        fillStarButtonImage()
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
        repository = item
        
        avatar.title = repository.name.first
        avatarLoader.loadOwnerAvatar(for: repository) { [weak self] avatarImage in
            main {
                self?.avatar.image = avatarImage
            }
        }
        fullName.text = repository.fullName
        descriptionTitle.text = repository.description ?? NSLocalizedString("Repository owner didn't provide description", comment: "")
        
        fillStarButtonImage()
        fillStarsCount()
    }
    
    private func fillStarButtonImage() {
        if favorites.contains(repository) {
            star.setImage(#imageLiteral(resourceName: "star-full"), for: .normal)
        } else {
            star.setImage(#imageLiteral(resourceName: "star-empty"), for: .normal)
        }
    }
    
    private func fillStarsCount() {
        let starsInThousands = Double(repository.stargazersCount) / 1_000.0
        if starsInThousands > 1 {
            if let starsInThousandsString = NumberFormatter.githubStars.string(from: NSNumber(value: starsInThousands)) {
                starCount.text = starsInThousandsString + "k"
            }
        }
        
        if starCount.text == nil {
            starCount.text = String(repository.stargazersCount)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        var newFrame = layoutAttributes.frame
        let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

private extension NumberFormatter {
    
    static let githubStars: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .floor
        return formatter
    }()
    
}
