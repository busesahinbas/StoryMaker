//
//  SettingsTableViewCell.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 19.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) weak var brightnessSlider: UISlider!
    @IBOutlet private(set) weak var contrastSlider: UISlider!
    @IBOutlet private(set) weak var shadowSlider: UISlider!
    
    static let identifier = "SettingsTableViewCell"
    
    var didChangeBrightness: ((Float) -> Void)?
    var didChangeContrast: ((Float) -> Void)?
    var didChangeShadow: ((Float) -> Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupTarget() {
        brightnessSlider.addTarget(self, action: #selector(brightnessSliderChanged), for: .valueChanged)
        contrastSlider.addTarget(self, action: #selector(contrastSliderChanged), for: .valueChanged)
        shadowSlider.addTarget(self, action: #selector(shadowSliderChanged), for: .valueChanged)
    }
    
    @objc private func brightnessSliderChanged(_ sender: UISlider) {
        didChangeBrightness?(sender.value)
    }
    
    @objc private func contrastSliderChanged(_ sender: UISlider) {
        didChangeContrast?(sender.value)
    }
    
    @objc private func shadowSliderChanged(_ sender: UISlider) {
        didChangeShadow?(sender.value)
    }
}
