//
//  StoriesCollectionViewCell.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    
    static let size = CGSize(width: 90, height: 90)

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.sb_roundAllCorners()
        imageView.sb_addBorder(size: 2, color: .systemOrange)
    }
    
    func configure(with user: User?) {
        nameLabel.text = user?.username
        imageView.sb_loadImageUsingCache(withUrlString: user?.profilePhotoUrl)
    }
    
}
