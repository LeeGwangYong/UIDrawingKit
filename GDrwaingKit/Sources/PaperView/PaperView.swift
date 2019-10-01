//
//  Paper.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

protocol PaperViewDelegate {

}

//protocol PaperViewDataSource: DrawingLayerDataSource  {
//    func brush(_ view: PaperView) -> Brush
//}

class PaperView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var drawingLayer: DrawingLayer!

    var delegate: PaperViewDelegate?
    var brush: Brush {
        get {
            return self.drawingLayer.brush
        }
        set {
            self.drawingLayer.brush = newValue
        }
    }
    var isDrawingEnable: Bool {
        get {
            return self.drawingLayer.isDrawingEnable
        }
        set {
            self.drawingLayer.isDrawingEnable = newValue
        }
    }
    
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
    
    public func undo() {
        self.drawingLayer.undoManager?.undo()
    }
    
    public func redo() {
        self.drawingLayer.undoManager?.redo()
    }
    
//    private func setUp(dataSource: PaperViewDataSource?) {
//        self.drawingLayer.brush = dataSource?.brush(self)
//    }
    
//    @objc
//    func push(drawingcontext: DrawingContext) {
//        let previousMainImage = self.mainImageView.image
//        let previousBackgoundImage = self.backgroundImageView.image
//        self.undoManager?.registerUndo(withTarget: self, handler: { (target) in
//            self.push(drawingcontext: DrawingContext(current: previousMainImage, background: previousBackgoundImage))
//        })
//        self.mainImageView.image = drawingcontext.current
//        self.backgroundImageView.image = drawingcontext.background
//    }
}
