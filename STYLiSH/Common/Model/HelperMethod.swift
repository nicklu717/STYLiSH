//
//  HelperMethod.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/16.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import Kingfisher

func isEvenNember(for number: Int) -> Bool {
    return number % 2 == 0
}

func setImage(for imageView: UIImageView, with imageURLString: String?) {
    if let imageURLString = imageURLString, let url = URL(string: imageURLString) {
        imageView.kf.setImage(with: url)
    }
}

func addTopBorder(for view: UIView) {
    
    let topBorder = CALayer()
    
    topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
    topBorder.backgroundColor = UIColor(white: 0, alpha: 0.25).cgColor
    
    view.layer.addSublayer(topBorder)
}
