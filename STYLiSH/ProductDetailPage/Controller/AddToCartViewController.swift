//
//  AddToCartViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/23.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData

class AddToCartViewController: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UITextFieldDelegate {
    
    var currentProduct: Product!
    
    // Element Outlets
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var colorCollectionView: AddToCartColorCollectionView!
    var colorSelectedIndexPath: IndexPath!
    
    @IBOutlet weak var sizeCollectionView: AddToCartSizeCollectionView!
    var sizeSelectedIndexPath: IndexPath!
    
    @IBOutlet weak var stockLabel: UILabel!
    var variantIndex: Int! {
        
        guard
            let colorSelectedIndexPath = colorSelectedIndexPath,
            let sizeSelectedIndexPath = sizeSelectedIndexPath
        else {
            return nil
        }
        
        return sizeSelectedIndexPath.row + (colorSelectedIndexPath.row * currentProduct.sizes.count)
    }
    
    @IBOutlet weak var substractAmountButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addAmountButton: UIButton!
    var currentAmount = 1
    
    let alert = SCLAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        
        amountTextField.delegate = self
        
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.text = currentProduct.title
        priceLabel.text = "NT$ \(currentProduct.price)"
        
        substractAmountButton.layer.borderColor = UIColor.black.cgColor
        substractAmountButton.layer.borderWidth = 1
        amountTextField.layer.borderColor = UIColor.black.cgColor
        amountTextField.layer.borderWidth = 1
        addAmountButton.layer.borderColor = UIColor.black.cgColor
        addAmountButton.layer.borderWidth = 1
    }
    
    // Comform Collection View Data Source Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case is AddToCartColorCollectionView: return currentProduct.colors.count
        case is AddToCartSizeCollectionView: return currentProduct.sizes.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case is AddToCartColorCollectionView:
            
            guard
                let colorCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ColorCell",
                    for: indexPath
                ) as? AddToCartColorCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let currentColor = UIColor(hex: currentProduct.colors[indexPath.row].code)
            colorCell.colorView.backgroundColor = currentColor
            
            colorCell.layer.borderColor = UIColor.black.cgColor
            colorCell.layer.borderWidth = 0
            
            colorCell.colorHexStringLabel.text = currentProduct.colors[indexPath.row].code
            
            return colorCell
            
        case is AddToCartSizeCollectionView:
            
            guard
                let sizeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "SizeCell",
                    for: indexPath
                ) as? AddToCartSizeCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let currentSize = currentProduct.sizes[indexPath.row]
            sizeCell.sizeLabel.text = currentSize
            
            sizeCell.layer.borderColor = UIColor.black.cgColor
            sizeCell.layer.borderWidth = 0
            
            return sizeCell
            
        default: return UICollectionViewCell()
        }
    }
    
    // Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case is AddToCartColorCollectionView:
            
            if colorSelectedIndexPath != indexPath {
                
                colorSelectedIndexPath = indexPath
                enableSizeCellWithStock()
                
                if let selectedColorCell = colorCollectionView.cellForItem(at: colorSelectedIndexPath) {
                    selectedColorCell.layer.borderWidth = 1
                }
            
                if
                    let sizeSelectedIndexPath = sizeSelectedIndexPath,
                    let selectedSizeCell = sizeCollectionView.cellForItem(at: sizeSelectedIndexPath) {
                        selectedSizeCell.layer.borderWidth = 0
                }
            
                sizeSelectedIndexPath = nil
            
                disableElementsWhenSelectingColorCell()
            }
            
        case is AddToCartSizeCollectionView:
            
            if colorSelectedIndexPath == nil { return }
            
            if sizeSelectedIndexPath != indexPath {
                
                sizeSelectedIndexPath = indexPath
                
                let stock = currentProduct.variants[variantIndex].stock
                
                if let selectedSizeCell = sizeCollectionView.cellForItem(at: sizeSelectedIndexPath), stock != 0 {
                    selectedSizeCell.layer.borderWidth = 1
                    enableElementsWhenSelectionSizeCell()
                } else {
                    disableElementsWhenSelectingColorCell()
                    sizeSelectedIndexPath = nil
                }
            
                stockLabel.text = String.localizedStringWithFormat(NSLocalizedString("庫存：", comment: ""), stock)
            }
            
        default: return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case is AddToCartColorCollectionView:
            
            if let deselectedColorCell = colorCollectionView.cellForItem(at: indexPath) {
                deselectedColorCell.layer.borderWidth = 0
            }
        
        case is AddToCartSizeCollectionView:
            
            if let deselectedSizeCell = sizeCollectionView.cellForItem(at: indexPath) {
                deselectedSizeCell.layer.borderWidth = 0
            }
        
        default: return
        }
    }
    
    // Button Methods
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func substractAmount() {
        
        if currentAmount > 1 {
            setAmount(to: currentAmount - 1)
        }
    }
    
    @IBAction func addAmount() {
        
        let stock = currentProduct.variants[variantIndex].stock
        
        if currentAmount < stock {
            setAmount(to: currentAmount + 1)
        }
    }
    
    // Handle Text Field Event
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard
            let amountTextFieldTextUserInput = amountTextField.text,
            let amountUserInput = Int(amountTextFieldTextUserInput)
            else {
                return
        }
        
        setAmount(to: amountUserInput)
        checkStock()
    }
    
    // Add to Cart Alert
    @IBAction func addToCart() {
        
        if colorSelectedIndexPath == nil {
            alert.showWarning(NSLocalizedString("Wait!", comment: ""), subTitle: NSLocalizedString("Please Pick a Color", comment: ""))
        } else if sizeSelectedIndexPath == nil {
            alert.showWarning(NSLocalizedString("Wait!", comment: ""), subTitle: NSLocalizedString("Please Choose the Size", comment: ""))
        } else {
            saveProductIntoCart()
            alert.showSuccess(NSLocalizedString("Success!", comment: ""), subTitle: NSLocalizedString("Added to Cart", comment: ""))
            dismiss(animated: true)
        }
    }
    
    // Helper Methods
    func enableSizeCellWithStock() {
        
        for sizeCellIndex in 0 ..< currentProduct.sizes.count {
            
            guard
                let sizeCell = sizeCollectionView.cellForItem(
                    at: IndexPath(row: sizeCellIndex, section: 0)
                    ) as? AddToCartSizeCollectionViewCell
                else {
                    return
            }
            
            let variantIndex = sizeCellIndex + (colorSelectedIndexPath.row * currentProduct.sizes.count)
            if currentProduct.variants[variantIndex].stock != 0 {
                sizeCell.sizeLabel.textColor = UIColor.grayishBrown
                sizeCell.imageView.image = nil
            } else {
                sizeCell.sizeLabel.textColor = UIColor(hex: "CCCCCC")
                sizeCell.imageView.image = UIImage(named: "Image_StrikeThrough")
            }
        }
    }
    
    func disableElementsWhenSelectingColorCell() {
        
        stockLabel.isHidden = true
        substractAmountButton.isEnabled = false
        addAmountButton.isEnabled = false
        amountTextField.isEnabled = false
        amountTextField.textColor = UIColor(hex: "CCCCCC")
        setAmount(to: 1)
    }
    
    func enableElementsWhenSelectionSizeCell() {
        
        stockLabel.isHidden = false
        substractAmountButton.isEnabled = true
        addAmountButton.isEnabled = true
        amountTextField.isEnabled = true
        amountTextField.textColor = UIColor.grayishBrown
        setAmount(to: 1)
    }
    
    func setAmount(to amount: Int) {
        currentAmount = amount
        amountTextField.text = String(currentAmount)
    }
    
    func checkStock() {
        
        let stock = currentProduct.variants[variantIndex].stock
        
        if currentAmount == 0 {
            setAmount(to: 1)
        }
        
        if currentAmount > stock {
            setAmount(to: stock)
        }
    }
    
    func saveProductIntoCart() {
        
        let storageManager = StorageManager.sharedInstance
        let cartContext = StorageManager.sharedInstance.persistentContainer.viewContext
        
        guard
            let cartProductEntity = NSEntityDescription.entity(forEntityName: "CartProduct", in: cartContext)
        else {
            print("Couldn't find the cart product entity.")
            return
        }
        
        let cartProduct = CartProduct(entity: cartProductEntity, insertInto: cartContext)
        
        cartProduct.image = currentProduct.mainImage
        cartProduct.title = currentProduct.title
        cartProduct.colorCode = currentProduct.colors[colorSelectedIndexPath.row].code
        cartProduct.colorName = currentProduct.colors[colorSelectedIndexPath.row].name
        cartProduct.size = currentProduct.sizes[sizeSelectedIndexPath.row]
        cartProduct.price = Int16(currentProduct.price)
        cartProduct.amount = Int16(currentAmount)
        cartProduct.id = "\(currentProduct.id)"
        
        storageManager.cartProductList.append(cartProduct)
    }
}
