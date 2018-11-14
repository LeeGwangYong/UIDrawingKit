//
//  ColorCollectionViewCell.swift
//  GDrawingKit
//
//  Created by 이광용 on 12/11/2018.
//  Copyright © 2018 GwangYongLee. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    var color: UIColor? {
        didSet {
            self.colorView.backgroundColor = color
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
