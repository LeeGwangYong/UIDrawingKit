//
//  NSObject+ReuseIdentifier.swift
//  UIDrawingKit
//
//  Created by 이광용 on 06/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
