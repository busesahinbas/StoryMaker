//
//  ToolType.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 19.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import UIKit

enum ToolType: String, CaseIterable {
    case crop = "Crop"
    case canvas = "Canvas"
    case filters = "Filters"
    case effect = "Effect"
    case text = "Text"
    case frame = "Frame"
    
    var iconName: String {
        switch self {
        case .crop: return "crop"
        case .canvas: return "square.and.pencil"
        case .filters: return "wand.and.stars"
        case .effect: return "sparkles"
        case .text: return "textformat"
        case .frame: return "square.on.square"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}
