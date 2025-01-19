//
//  UIButton+Extensions.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 19.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UIButton Extensions
extension UIButton {
    func centerImageAndButton(spacing: CGFloat = 6.0) {
        guard let imageView = self.imageView,
              let titleLabel = self.titleLabel else { return }
        
        if let imageSize = imageView.image?.size,
           let font = titleLabel.font {
            let titleSize = titleLabel.text?.size(withAttributes: [.font: font]) ?? .zero
            
            let totalHeight = imageSize.height + spacing + titleSize.height
            
            self.imageEdgeInsets = UIEdgeInsets(
                top: -(totalHeight - imageSize.height),
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )
            
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageSize.width,
                bottom: -(totalHeight - titleSize.height),
                right: 0
            )
        }
    }
}
