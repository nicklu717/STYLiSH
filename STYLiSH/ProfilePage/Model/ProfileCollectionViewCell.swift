//
//  ProfileCollectionViewCell.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    var iconImageView = UIImageView()
    var functionNameLabel = UILabel()
    
    func setupCollectionViewCellLayoutConstraints() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(functionNameLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        functionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            functionNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            functionNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
    }
}
