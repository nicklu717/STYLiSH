//
//  TableViewPrototypeCell.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class DisplayCellWithOneImage: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}

class DisplayCellWithFourImage: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerTopImageView: UIImageView!
    @IBOutlet weak var centerBottomImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}
