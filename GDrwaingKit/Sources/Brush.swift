//
//  Brush.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

class Brush: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Brush(type: self.type)
        copy.width = self.width
        copy.alpha = self.alpha
        copy.color = self.color
        return copy
    }
    
    enum BrushType {
        case normal, eraser
        
        var blendMode: CGBlendMode {
            switch self {
            case .normal:
                return .normal
            case .eraser:
                return .clear
            }
        }
    }
    
    var width: CGFloat = 10.0
    var alpha: CGFloat = 1.0
    var color: UIColor = .black
    var type: BrushType
    
    init(type: BrushType) {
        self.type = type
        if self.type == .eraser {
            self.color = .clear
        }
    }
}

extension Brush: Equatable {
    static func == (lhs: Brush, rhs: Brush) -> Bool {
        return (lhs.width == rhs.width) && (lhs.alpha == rhs.alpha) && (lhs.color == rhs.color) && (lhs.type == rhs.type)
    }
}
