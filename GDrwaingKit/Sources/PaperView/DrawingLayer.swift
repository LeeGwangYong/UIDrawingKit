//
//  DrawLayer.swift
//  GDrawingKit
//
//  Created by 이광용 on 25/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit
//https://developer.apple.com/videos/play/wwdc2016/220/
//https://developer.apple.com/documentation/uikit/pencil_interactions/handling_input_from_apple_pencil
//https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_touches_in_your_view/getting_high-fidelity_input_with_coalesced_touches
//https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_touches_in_your_view/getting_high-fidelity_input_with_coalesced_touches/implementing_coalesced_touch_support_in_an_app
//https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_touches_in_your_view/minimizing_latency_with_predicted_touches/incorporating_predicted_touches_into_an_app

//http://merowing.info/2012/04/drawing-smooth-lines-with-cocos2d-ios-inspired-by-paper/
//https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UndoArchitecture/UndoArchitecture.html
//https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/DrawingTips/DrawingTips.html
//https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html
//https://developer.apple.com/library/archive/samplecode/QuartzDemo/Listings/QuartzDemo_QuartzLineView_swift.html#//apple_ref/doc/uid/DTS40007531-QuartzDemo_QuartzLineView_swift-DontLinkElementID_21

protocol DrawingLayerDelegate {
}

class DrawingLayer: UIView {
    private var drawingContexts: [DrawingContext]  = []
    private var points: [CGPoint] = []
    public var brush: Brush!
    public var isDrawingEnable: Bool = true
    public var delegate: DrawingLayerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpDrawingLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpDrawingLayer()
    }
    
    private func setUpDrawingLayer() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
//        self.draw(UIGraphicsGetCurrentContext()!)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        
        for line in self.drawingContexts {
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setLineWidth(line.brush.width)
            // set blend mode so an eraser actually erases stuff
            context.setBlendMode(line.brush.type.blendMode)
            context.setAlpha(line.brush.alpha)
            context.setStrokeColor(line.brush.color.cgColor)
            context.addPath(line.path)
            context.strokePath()
        }
    }
    
//    private func draw(_ context: CGContext) {
//        context.setLineCap(.round)
//        context.setLineJoin(.round)
//        for item in self.drawingContexts {
//            context.setLineWidth(item.brush.width / UIScreen.main.scale)
//            context.setBlendMode(item.brush.type.blendMode)
//            context.setAlpha(item.brush.alpha)
//            context.setStrokeColor(item.brush.color.cgColor)
//            context.addPath(item.path)
//            context.strokePath()
//        }
//
//    }
//
    var previous: CGPoint = .zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.isDrawingEnable else { return }
        
        debugPrint("touchesBegan : \(touch.location(in: self))")
        
        /*  NEED TO UPGARDE
         `move(to:)` -> `addPath(path:)`
         */
        setTouchPoints(touch, view: self)
        let drawingContext = DrawingContext(path: CGMutablePath(), brush: self.brush.copy() as! Brush )
        drawingContext.path.addPath(createNewPath())
        self.drawingContexts.append(drawingContext)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.isDrawingEnable else { return }
        let point = touch.location(in: self)
        
        debugPrint("touchesMoved : \(point)")
//        if let drawingContext = self.drawingContexts.last {
//            /*  NEED TO UPGARDE
//            `addLine(to:)` -> `addPath(path:)`
//            */
//            drawingContext.path.addLine(to: point)
//            drawingContext.draw(at: self)
//        }
    
        updateTouchPoints(for: touch, in: self)
        let newLine = createNewPath()
        if let currentPath = drawingContexts.last {
            currentPath.path.addPath(newLine)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.isDrawingEnable else { return }
        debugPrint("touchesEnded : \(touch.location(in: self))")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.isDrawingEnable else { return }
        debugPrint("touchesCancelled : \(touch.location(in: self))")
        self.touchesEnded(touches, with: event)
    }
    //https://stackoverflow.com/questions/8702696/drawing-smooth-curves-methods-needed
    private var currentPoint: CGPoint = .zero
    private var previousPoint: CGPoint = .zero
    private var previousPreviousPoint: CGPoint = .zero
    
    private func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        previousPreviousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func updateTouchPoints(for touch: UITouch,in view: UIView) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func createNewPath() -> CGMutablePath {
        let midPoints = getMidPoints()
        let subPath = createSubPath(midPoints.0, mid2: midPoints.1)
        let newPath = addSubPathToPath(subPath)
        return newPath
    }
    
    private func calculateMidPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5);
    }
    
    private func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = calculateMidPoint(previousPoint, p2: previousPreviousPoint)
        let mid2 : CGPoint = calculateMidPoint(currentPoint, p2: previousPoint)
        return (mid1, mid2)
    }
    
    private func createSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint.x, y: previousPoint.y))
        return subpath
    }
    
    private func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * brush.width, dy: -2.0 * brush.width)
        self.setNeedsDisplay(drawBox)
        return subpath
    }
}

extension DrawingContext {
    
//    func smoothDrawing(at view: UIView, previous: CGPoint, current: CGPoint) {
//        self.appendPath(previousPoint: previous, currentPoint: current)
//        self.draw(at: view)
//    }
//
//    func appendPath(previousPoint p1: CGPoint, currentPoint p2: CGPoint) {
//        // 1.
//        let midPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
//        self.path.addQuadCurve(to: midPoint, control: p1)
//    }
    
    func draw(at view: UIView) {
        let bounds : CGRect = self.path.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -1 * self.brush.width,
                                              dy: -1 * self.brush.width)
        /*
         If you are calling setNeedsDisplay:, always spend the time to calculate the actual area that you need to redraw. Don’t just pass a rectangle containing the entire view.
         Also, don’t call setNeedsDisplay: unless you actually need to redraw content. If the content hasn’t actually changed, don’t redraw it.
         */
        view.setNeedsDisplay(drawBox)
    }
}
