//
//  UIImage + Convert.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func png() -> UIImage? {
        guard let data = self.pngData() else {return nil}
        return UIImage(data: data)
    }
    
    func jpeg(quality: CGFloat = 1.0) -> UIImage? {
        guard let data = self.jpegData(compressionQuality: quality) else {return nil}
        return UIImage(data: data)
    }
}

extension UIImageView {
    func png() -> UIImage? {
        guard let image = self.image else {return nil}
        return image.png()
    }
    
    func jpeg(quality value: CGFloat = 1.0) -> UIImage? {
        guard let image = self.image else {return nil}
        return image.jpeg(quality: value)
    }
}
