//
//  Paper.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

protocol PaperViewDelegate {
//    func paperView(_ view: PaperView, drawingContext: DrawingContext)
}
class PaperView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    private var curvePoints: [CGPoint] = [.zero]
    private let bezielPath: UIBezierPath = UIBezierPath()
    var brush: Brush?
    var delegate: PaperViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpPaperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpPaperView()
    }
    
    private func setUpPaperView() {
        Bundle.main.loadNibNamed(PaperView.reuseIdentifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.backgroundImageView.backgroundColor = .white
        
        self.bezielPath.lineCapStyle = .round
        self.bezielPath.lineJoinStyle = .round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let currentPoint = touch.location(in: self)
        self.bezielPath.removeAllPoints()
        self.bezielPath.move(to: currentPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let currentPoint = touch.location(in: self)
        debugPrint(currentPoint)
        self.bezielPath.addLine(to: currentPoint)
        self.drawPath()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let currentPoint = touch.location(in: self)
        self.bezielPath.addLine(to: currentPoint)
        self.mergePaths()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
    
    
    private func drawPath() {
        guard let brush = self.brush else {fatalError("There is no brush")}
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.bezielPath.lineWidth = brush.width / UIScreen.main.scale
        brush.color.setStroke()
        
        var imageView: UIImageView
        switch brush.type {
        case .eraser:
            self.mainImageView.image?.draw(in: self.bounds)
            imageView = self.mainImageView
        default:
            imageView = self.tempImageView
        }
        
        self.bezielPath.stroke(with: brush.type.blendMode, alpha: brush.alpha)
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func mergePaths() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.mainImageView.image?.draw(in: self.bounds)
        self.tempImageView.image?.draw(in: self.bounds)
        
        self.tempImageView.image = nil
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        let backgroundImage = self.backgroundImageView.image
        self.push(DrawingContext(current: currentImage,
                                 background: backgroundImage))
        
        UIGraphicsEndImageContext()
    }
    
    @objc
    func push(_ drawingcontext: DrawingContext) {
        let previousMainImage = self.mainImageView.image
        let previousBackgoundImage = self.backgroundImageView.image
        self.undoManager?.registerUndo(withTarget: self, handler: { (target) in
            self.push(DrawingContext(current: previousMainImage, background: previousBackgoundImage))
        })
        self.mainImageView.image = drawingcontext.current
        self.backgroundImageView.image = drawingcontext.background
    }
}
