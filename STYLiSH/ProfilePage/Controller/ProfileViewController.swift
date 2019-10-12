//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout {
    
    let collectionViewItemWidth = CGFloat(integerLiteral: 60)
    
    let profileView = UIView()
    let profilePhotoImageView = UIImageView()
    let profileNameLabel = UILabel()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Navigation Bar Title
        
        self.navigationItem.title = NSLocalizedString("Profile", comment: "")
        
        // Profile Panel
        
        profileView.backgroundColor = UIColor.grayishBrown
        
        profilePhotoImageView.image = UIImage(named: "Icons_36px_Profile_Normal")
        profileView.addSubview(profilePhotoImageView)
        
        profileNameLabel.text = "AppWorks School"
        profileNameLabel.textColor = UIColor.white
        profileNameLabel.font = UIFont(name: "NotoSans-Regular", size: 18)
        profileView.addSubview(profileNameLabel)
        
        self.view.addSubview(profileView)
        
        // Collection View
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                             left: standardMargin,
                                                             bottom: 0,
                                                             right: standardMargin)
        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewItemWidth, height: 51)
        collectionViewFlowLayout.minimumLineSpacing = CGFloat(integerLiteral: 24)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 72)
        
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: 92,
                                                        width: screenBound.width,
                                                        height: screenBound.height),
                                          collectionViewLayout: collectionViewFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ProfileCollectionViewCell.self,
                                forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.register(ProfileCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ProfileCollectionViewHeader")
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: profileView.bottomAnchor)])
    }
    
    override func viewWillLayoutSubviews() {
        setupProfileViewLayoutConstraints()
    }
    
    // MARK: Setup Collection View

    // Section 數量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return serviceList.sections.count
    }
    
    // 每個 Section 的 Item 數
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceList.sections[section].functions.count
    }
    
    // Section 內 Item 間距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        switch section {
        case 0:
            let spaceForFiveItemsInRow = (screenBound.width - standardMargin * 2 - collectionViewItemWidth * 5) / 4
            return spaceForFiveItemsInRow
        default:
            let spaceForFourItemsInRow = (screenBound.width - standardMargin * 2 - collectionViewItemWidth * 4) / 3
            return spaceForFourItemsInRow - 1
        }
    }
    
    // Header 內容
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "ProfileCollectionViewHeader",
                for: indexPath
            ) as? ProfileCollectionViewHeader
        else {
            return UICollectionReusableView()
        }
        
        collectionViewHeader.sectionNameLabel.text = serviceList.sections[indexPath.section].name
        collectionViewHeader.sectionNameLabel.textColor = UIColor.grayishBrown
        collectionViewHeader.sectionNameLabel.font = UIFont(name: "NotoSans-Regular", size: 16)
        
        collectionViewHeader.viewAllButton.setTitle(NSLocalizedString("ViewAll", comment: ""), for: .normal)
        collectionViewHeader.viewAllButton.setTitleColor(UIColor.brownishGrey, for: .normal)
        collectionViewHeader.viewAllButton.titleLabel?.font = UIFont(name: "NotoSans-Regular", size: 13)
        
        if indexPath.section != 0 {
            collectionViewHeader.viewAllButton.isHidden = true
        }
        
        collectionViewHeader.setupCollectionViewHeaderLayoutConstraints()
        
        return collectionViewHeader
    }
    
    // Item 內容
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let collectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProfileCollectionViewCell",
                for: indexPath
            ) as? ProfileCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let currentFunction = serviceList.sections[indexPath.section].functions[indexPath.row]
        
        collectionViewCell.iconImageView.image = currentFunction.icon
        
        collectionViewCell.functionNameLabel.text = currentFunction.name
        collectionViewCell.functionNameLabel.textColor = UIColor.grayishBrown
        collectionViewCell.functionNameLabel.font = UIFont(name: "NotoSans-Regular", size: 13)
        
        collectionViewCell.setupCollectionViewCellLayoutConstraints()
        
        return collectionViewCell
    }
    
    // MARK: Constraints Methods
    
    func setupProfileViewLayoutConstraints() {
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            profileView.heightAnchor.constraint(equalToConstant: 92),
            profileView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 60),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 60),
            profilePhotoImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 16),
            
            profileNameLabel.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: 16)
        ])
    }
}
