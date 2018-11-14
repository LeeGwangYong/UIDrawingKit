//
//  Brush.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

class Brush {
    enum BrushType {
        case ink, eraser
        
        var blendMode: CGBlendMode {
            switch self {
            case .ink:
                return .normal
            case .eraser:
                return .clear
            }
        }
    }
    
    var width: CGFloat = 5.0
    var alpha: CGFloat = 1.0
    var color: UIColor = .black
    let type: BrushType
    
    init(type: BrushType) {
        self.type = type
        if self.type == .eraser {
            self.color = .clear
        }
    }
}
