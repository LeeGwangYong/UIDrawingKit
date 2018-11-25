//
//  DrawingKit.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit


class DrawingContext: NSObject {
    var current: UIImage?
    var background: UIImage?
    
    init(current: UIImage? = nil, background: UIImage? = nil) {
        self.current = current
        self.background = background
    }
}

