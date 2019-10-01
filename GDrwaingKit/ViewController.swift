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
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let inkBrush = Brush(type: .normal)
    let eraseBrush = Brush(type: .eraser)
    let colors: [UIColor] = [.black, .red, .green, .blue, .orange, .brown]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canvasView.delegate = self
        self.canvasView.brush = self.inkBrush
        
        self.canvasView.showsVerticalScrollIndicator = false
        self.canvasView.showsHorizontalScrollIndicator = false
        
        
        self.widthSlider.minimumValue = 0.1
        self.widthSlider.maximumValue = 100.0
        self.widthSlider.value = Float(self.canvasView.brush.width)
        
        self.alphaSlider.minimumValue = 0.0
        self.alphaSlider.maximumValue = 1.0
        self.alphaSlider.value = Float(self.canvasView.brush.alpha)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ColorCollectionViewCell"
            , bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

    }

    @IBAction func inkButton(_ sender: UIButton) {
        self.canvasView.brush = self.inkBrush
        self.collectionView.isHidden = false
        self.alphaSlider.isHidden = false
        self.widthSlider.setValue(Float(self.canvasView.brush.width), animated: true)
        self.alphaSlider.setValue(Float(self.canvasView.brush.alpha), animated: true)
    }
    
    @IBAction func eraseButton(_ sender: UIButton) {
        self.canvasView.brush = self.eraseBrush
        self.collectionView.isHidden = true
        self.alphaSlider.isHidden = true
        self.widthSlider.setValue(Float(self.canvasView.brush.width), animated: true)
        self.alphaSlider.setValue(Float(self.canvasView.brush.alpha), animated: true)
    }
    
    @IBAction func widthSliderValueChanged(_ sender: UISlider) {
        self.canvasView.brush.width = CGFloat(sender.value)
    }
    
    @IBAction func alphaSliderValueChanged(_ sender: UISlider) {
        self.canvasView.brush.alpha = CGFloat(sender.value)
    }
    
    @IBAction func undoButotnPressed(_ sender: UIButton) {
        self.canvasView.undo()
    }
    
    @IBAction func redoButtonPressed(_ sender: UIButton) {
        self.canvasView.redo()
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.color = self.colors[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.height, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Brush Equalable
//        if let currentBrush = self.canvasView.currentBrush {
//
//        }
        
        self.inkBrush.color = self.colors[indexPath.row]
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = .gray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
    }

}

extension ViewController: CanvasViewDelegate {
    func canvasView(_ view: CanvasView, scale: CGFloat) {
        
    }
    
    func canvasView(_ view: CanvasView, isUndoable: Bool) {
        
    }
    
    func canvasView(_ view: CanvasView, isRedoable: Bool) {
        
    }
    
    
}
