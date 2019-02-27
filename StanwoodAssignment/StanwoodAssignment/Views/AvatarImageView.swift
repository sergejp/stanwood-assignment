//
//  AvatarImageView.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit

final class AvatarImageView: UIImageView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String = "" {
        didSet {
            updateTitleLabel()
        }
    }
    
    override var image: UIImage? {
        didSet {
            titleLabel.isHidden = image != nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        layer.masksToBounds = true
        backgroundColor = .gray
        
        if titleLabel.superview == nil {
            addSubview(titleLabel)
            titleLabel.textAlignment = .center
//            NSLayoutConstraint.activate([
//                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//                ])
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTitleLabel()
        layer.cornerRadius = (min(bounds.height, bounds.width) / 2).rounded(.down)
    }
    
    private func updateTitleLabel() {
        let fontSize = (bounds.height / 2).rounded(.up)
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        titleLabel.text = title
    }
    
}
