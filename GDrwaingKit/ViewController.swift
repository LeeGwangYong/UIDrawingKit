//
//  ViewController.swift
//  UIDrawingKit
//
//  Created by 이광용 on 05/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var canvasView: CanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.canvasView.delegate = self
        self.canvasView.showsVerticalScrollIndicator = false
        self.canvasView.showsHorizontalScrollIndicator = false
    }
}

extension ViewController: CanvasViewDelegate {
    func canvasView(_ view: CanvasView, scale: CGFloat) {
    }
}
