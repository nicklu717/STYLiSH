//
//  CartTableViewCell.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    weak var delegate: UITableView?
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var subtrackAmountButton: UIButton!
    @IBOutlet weak var addAmountButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    var currentAmount: Int!
    
    @IBAction func substractAmount() {
        if currentAmount > 1 {
            setAmount(to: currentAmount - 1)
            updateData()
        }
    }
    
    @IBAction func addAmount() {
        setAmount(to: currentAmount + 1)
        updateData()
    }
    
    func setAmount(to amount: Int) {
        currentAmount = amount
        amountLabel.text = String(currentAmount)
    }
    
    @IBAction func deleteProduct() {
        
        let storageManager = StorageManager.sharedInstance
        let cartContext = storageManager.persistentContainer.viewContext
        
        if let indexPath = delegate?.indexPath(for: self) {
            
            let selectedProductObject = storageManager.cartProductList[indexPath.row]
            cartContext.delete(selectedProductObject)
            
            print("cart product list will removing")
            storageManager.cartProductList.remove(at: indexPath.row)
            
//            print("Deleting \(indexPath)")
//            delegate?.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateData() {
        
        let storageManager = StorageManager.sharedInstance
        
        if let indexPath = delegate?.indexPath(for: self) {
            
            let selectedProductObject = storageManager.cartProductList[indexPath.row]
            
            selectedProductObject.setValue(currentAmount, forKey: "amount")
        }
    }
}
