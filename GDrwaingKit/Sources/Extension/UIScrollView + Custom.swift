//
//  UIScrollView + Custom.swift
//  UIDrawingKit
//
//  Created by 이광용 on 10/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func fitZoomScale(_ view: UIView) -> CGFloat {
        let scale = min(self.bounds.size.width / view.bounds.size.width,
                        self.bounds.size.height / view.bounds.size.height)
        //        return 1.0 < scale ? 1.0 : scale
        return scale
    }
    
    func moveToCenter(_ view: UIView) {
        let childFrame = view.frame.size
        let scrollViewBound = self.bounds.size
        
        let verticalPadding = childFrame.height < scrollViewBound.height ? (scrollViewBound.height - childFrame.height) / 2 : 0.0
        let horizontalPadding = childFrame.width < scrollViewBound.width ? (scrollViewBound.width - childFrame.width) / 2 : 0.0
        
        self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

