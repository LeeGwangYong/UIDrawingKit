//
//  Brush.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

class Brush: NSObject {
    var width: CGFloat = 5.0
    var alpha: CGFloat = 1.0
    var color: UIColor = .black {
        didSet {
            if color.isEqual(UIColor.clear) {
                self.blendMode = .clear
            }
        }
    }
    var blendMode: CGBlendMode = .normal
}
