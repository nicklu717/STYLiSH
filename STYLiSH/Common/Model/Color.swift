//
//  Color.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let grayishBrown = UIColor(red: 63/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1)
    static let brownishGrey = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt32 = 0
        
        scanner.scanHexInt32(&rgbValue)
        
        let redValue = (rgbValue & 0xff0000) >> 16
        let greenValue = (rgbValue & 0xff00) >> 8
        let blueValue = rgbValue & 0xff
        
        self.init(
            red: CGFloat(redValue) / 0xff,
            green: CGFloat(greenValue) / 0xff,
            blue: CGFloat(blueValue) / 0xff,
            alpha: 1
        )
    }
}
