//
//  CanvasViewDelegateProxy.swift
//  UIDrawingKit
//
//  Created by 이광용 on 10/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import Foundation
import UIKit

extension CanvasView {
    class CanvasViewDelegateProxy: NSObject, UIScrollViewDelegate {
        weak var _userDelegate: CanvasViewDelegate?
        
        override func responds(to aSelector: Selector!) -> Bool {
            return super.responds(to: aSelector) || _userDelegate?.responds(to: aSelector) == true
        }
        
        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if _userDelegate?.responds(to: aSelector) == true {
                return _userDelegate
            } else {
                return super.forwardingTarget(for: aSelector)
            }
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            if let canvasView = scrollView as? CanvasView {
                return canvasView.viewForZooming
            }
            return nil
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if let canvasView = scrollView as? CanvasView {
                _userDelegate?.scrollViewDidZoom?(canvasView)
                _userDelegate?.canvasView(canvasView, scale: scrollView.zoomScale)
            }
        }
    }
}

