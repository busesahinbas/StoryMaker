//
//  FilterType.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 19.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import UIKit
import CoreImage

enum FilterType: String, CaseIterable {
    case original = "Original"
    case mono = "Mono"
    case chrome = "Chrome"
    case fade = "Fade"
    case instant = "Instant"
    case noir = "Noir"
    case process = "Process"
    case tonal = "Tonal"
    case transfer = "Transfer"
    
    var filter: CIFilter? {
        switch self {
        case .original:
            return nil
        case .mono:
            return CIFilter(name: "CIPhotoEffectMono")
        case .chrome:
            return CIFilter(name: "CIPhotoEffectChrome")
        case .fade:
            return CIFilter(name: "CIPhotoEffectFade")
        case .instant:
            return CIFilter(name: "CIPhotoEffectInstant")
        case .noir:
            return CIFilter(name: "CIPhotoEffectNoir")
        case .process:
            return CIFilter(name: "CIPhotoEffectProcess")
        case .tonal:
            return CIFilter(name: "CIPhotoEffectTonal")
        case .transfer:
            return CIFilter(name: "CIPhotoEffectTransfer")
        }
    }
} 
