//
//  ProfileCollectionViewHeader.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileCollectionViewHeader: UICollectionReusableView {
    
    var sectionNameLabel = UILabel()
    var viewAllButton = UIButton()
    
    func setupCollectionViewHeaderLayoutConstraints() {
        self.addSubview(sectionNameLabel)
        self.addSubview(viewAllButton)
        
        sectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sectionNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            viewAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
    }
}
