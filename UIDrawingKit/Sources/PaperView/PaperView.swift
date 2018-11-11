//
//  Paper.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

class PaperView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var curvePoints: [CGPoint] = [.zero]
    let bezielPath: UIBezierPath = UIBezierPath()
    var brush = Brush()
    var drawingContext = DrawingContext()
    
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
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.bezielPath.lineWidth = self.brush.width / UIScreen.main.scale
        self.brush.color.setStroke()
        self.bezielPath.stroke(with: self.brush.blendMode, alpha: self.brush.alpha)
        
        self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func mergePaths() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.mainImageView.image?.draw(in: self.bounds)
        self.tempImageView.image?.draw(in: self.bounds)
        
        self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        self.tempImageView.image = nil
        
        UIGraphicsEndImageContext()
    }
}
