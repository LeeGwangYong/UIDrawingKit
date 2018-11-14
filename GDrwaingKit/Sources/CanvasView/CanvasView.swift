//
//  CanvasView.swift
//  UIDrawingKit
//
//  Created by 이광용 on 10/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

protocol CanvasViewDelegate: UIScrollViewDelegate {
    func canvasView(_ view: CanvasView, scale: CGFloat)
}

class CanvasView: UIScrollView {
    private let paperView: PaperView = PaperView(frame: CGRect(x: 0, y: 0, width: 1080, height: 720))
    private var delegateProxy = CanvasViewDelegateProxy()
    
    var brushColor: UIColor {
        get {
            return self.paperView.brush?.color ?? .clear
        }
        set {
            self.paperView.brush?.color = newValue
        }
    }
    
    var brushWidth: CGFloat {
        get {
            return self.paperView.brush?.width ?? 0.0
        }
        set {
            self.paperView.brush?.width = newValue
        }
    }
    
    var brushAlpha: CGFloat {
        get {
            return self.paperView.brush?.alpha ?? 0.0
        }
        set {
            self.paperView.brush?.alpha = newValue
        }
    }
    
    var currentBrush: Brush? {
        return self.paperView.brush
    }
    
    override var delegate: UIScrollViewDelegate? {
        get {
            return self.delegateProxy._userDelegate
        }
        set {
            self.delegateProxy._userDelegate = newValue as? CanvasViewDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.moveToCenter(self.paperView)
    }
    
    private func setUp() {
        super.delegate = self.delegateProxy
        self.setUpCanvasView()
        self.setUpGesture()
    }
    
    private func setUpCanvasView() {
        self.addSubview(self.paperView)
        self.contentSize = CGRect.zero.union(self.paperView.frame).size
        self.minimumZoomScale = 0.05
        self.maximumZoomScale = 3.0
        self.zoomScale = self.fitZoomScale(self.paperView)
    }
    
    private func setUpGesture() {
        if let gestures = self.gestureRecognizers {
            gestures.forEach { (gesture) in
                if gesture.isKind(of: UIPanGestureRecognizer.self),
                    let panGesture = gesture as? UIPanGestureRecognizer {
                    panGesture.minimumNumberOfTouches = 2
                }
            }
        }
    }
    
    var viewForZooming: UIView {
        return self.paperView
    }

    func set(_ brush: Brush) {
        self.paperView.brush = brush
        
    }
}
