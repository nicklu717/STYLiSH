//
//  CartViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var goToPayButton: UIButton!
    @IBOutlet weak var goToPaySuperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder(for: goToPaySuperView)
    }
    
    @objc func changeBadgeValue(notification: Notification) {
        if
            let userInfo = notification.userInfo,
            let newCartProductList = userInfo[NotificationInfo.newCartProductList] as? [CartProduct] {
            
                navigationController?.tabBarItem.badgeValue = "\(newCartProductList.count)"
            
                if newCartProductList.count == 0 {
                    goToPayButton.isHidden = true
                } else {
                    goToPayButton.isHidden = false
                }
        }
    }
    
    @objc func reloadTableView(notification: Notification) {
        print("table view will reload")
        tableView.reloadData()
        print("table view did reload")
        
        print("Row number: \(tableView.numberOfRows(inSection: 0))")
    }
    
    // Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageManager.sharedInstance.cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cartCell = tableView.dequeueReusableCell(
                withIdentifier: "CartTableViewCell",
                for: indexPath
            ) as? CartTableViewCell
        else {
            return UITableViewCell()
        }
        
        cartCell.delegate = tableView
        
        let currentProduct = StorageManager.sharedInstance.cartProductList[indexPath.row]
        
        setImage(for: cartCell.mainImageView, with: currentProduct.image)
        cartCell.titleLabel.text = currentProduct.title
        if let colorHex = currentProduct.colorCode {
            cartCell.colorView.backgroundColor = UIColor(hex: colorHex)
        }
        cartCell.sizeLabel.text = currentProduct.size
        cartCell.priceLabel.text = "NT$ \(currentProduct.price)"
        cartCell.setAmount(to: Int(currentProduct.amount))
            
        cartCell.subtrackAmountButton.layer.borderColor = UIColor.black.cgColor
        cartCell.subtrackAmountButton.layer.borderWidth = 1
        cartCell.amountLabel.layer.borderColor = UIColor.black.cgColor
        cartCell.amountLabel.layer.borderWidth = 1
        cartCell.addAmountButton.layer.borderColor = UIColor.black.cgColor
        cartCell.addAmountButton.layer.borderWidth = 1
        
        return cartCell
    }

    @IBAction func unwindToCartPage(_ segue: UIStoryboardSegue) {}
}
