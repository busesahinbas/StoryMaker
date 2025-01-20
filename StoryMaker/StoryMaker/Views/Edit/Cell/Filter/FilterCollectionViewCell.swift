//
//  FilterCollectionViewCell.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 17.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterCollectionViewCell"
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.contentMode = .scaleAspectFill
        filterImageView.clipsToBounds = true
        filterImageView.layer.cornerRadius = 8
    }
    
    func configure(with image: UIImage) {
        filterImageView.image = image
    }
} 
