//
//  DrawingKit.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit


struct DrawingContext {
    var path: CGMutablePath
    var brush: Brush
}

extension DrawingContext: Equatable {
    static func == (lhs: DrawingContext, rhs: DrawingContext) -> Bool {
        return (lhs.path == rhs.path) && (lhs.brush == rhs.brush)
    }
}
