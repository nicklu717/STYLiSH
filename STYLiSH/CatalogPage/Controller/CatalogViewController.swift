//
//  CatalogViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController,
                            ProductListManagerDelegate,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource {
    
    @IBOutlet weak var displayModeChangingButton: UIBarButtonItem!
    
    @IBOutlet weak var womenCatalogButton: UIButton!
    @IBOutlet weak var menCatalogButton: UIButton!
    @IBOutlet weak var accesoryCatalogButton: UIButton!
    
    @IBOutlet weak var buttonShadowView: UIView!
    @IBOutlet weak var selectedButtonIndicatorView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // Declare Request Manager
    let productListManager = ProductListManager()
    
    var womenProductList: ProductList!
    var menProductList: ProductList!
    var accessoriesProductList: ProductList!
    
    var productList: ProductList! {
        get {
            switch currentCategory {
                
            case .women: return womenProductList
            case .men: return menProductList
            case .accessories: return accessoriesProductList
            }
        }
        set {
            switch currentCategory {
                
            case .women: womenProductList = newValue
            case .men: menProductList = newValue
            case .accessories: accessoriesProductList = newValue
            }
        }
    }
    
    // Current Selected Status
    var displayMode: DisplayMode = .table
    var currentCategory: CurrentCategory = .women
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // MARK: Catalog Page Initializing
        
        // Navigation Bar Settings
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        // Assign Delegate
        tableView.delegate = self
        tableView.dataSource = self
        productListManager.delegate = self
        
        // Define Collection View Flow Layout
        let minimumInteritemSpacing = collectionViewFlowLayout.minimumInteritemSpacing
        
        collectionViewFlowLayout.itemSize.width = (screenBound.width - standardMargin * 2 - minimumInteritemSpacing) / 2
        collectionViewFlowLayout.itemSize.height = collectionViewFlowLayout.itemSize.width * 1.8
        
        // Default Category
        print("press button(default)")
        changeCatalog(womenCatalogButton)
        
        // MARK: Update Catalog Page
        
        // 加入 Pull-Down Refresher
        addPullDownRefresher()
        
        // 加入 Load-More Function
        addMoreDataLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Comform Request Delegate Protocol
    
    func manager(_ manager: ProductListManager, didGet newProductListForCurrentCategory: ProductList) {

        if self.productList == nil {
            self.productList = newProductListForCurrentCategory
            print("Product List: nil -> new")
        } else {
            self.productList.data += newProductListForCurrentCategory.data
            self.productList.paging = newProductListForCurrentCategory.paging
            print("Product List: Append")
        }
        
        reloadViewData()
    }
    
    func manager(_ manager: ProductListManager, didFailWith error: Error?) {
        stopRefreshingAndLoading()
    }
    
    // MARK: Tab Button Methods
    
    @IBAction func changeCatalog(_ sender: UIButton) {
        
        // Change Tab Button
        switch sender {
            
        case womenCatalogButton: currentCategory = .women
        case menCatalogButton: currentCategory = .men
        case accesoryCatalogButton: currentCategory = .accessories
        default: break
        }
        
        resetButtonTitleColor()
        sender.setTitleColor(UIColor.grayishBrown, for: .normal)
        
        UIView.animate(withDuration: 0.5) {
            self.selectedButtonIndicatorView.center.x = sender.center.x
        }
        
        if productList == nil {
            productListManager.requestProductList(for: currentCategory)
        } else {
            reloadViewData()
        }
    }
    
    @IBAction func changeDisplayMode(_ sender: UIBarButtonItem) {
        
        displayMode = (displayMode == .table ? .collection : .table)
        
        switch displayMode {
            
        case .table:
            displayModeChangingButton.image = UIImage(named: "Icons_24px_CollectionView")
            tableView.isHidden = false
            
        case .collection:
            displayModeChangingButton.image = UIImage(named: "Icons_24px_ListView")
            tableView.isHidden = true
        }
    }
    
    // MARK: Comform Table View Delegate Protocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let productList = productList else {
            return 0
        }
        
        return productList.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell",
                                                                for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        let currentProduct = productList.data[indexPath.row]
        
        let productImageURL = currentProduct.mainImage
        setImage(for: tableViewCell.productImageView, with: productImageURL)
        
        tableViewCell.productTitleLabel.text = currentProduct.title
        
        let productPrice = currentProduct.price
        tableViewCell.productPriceLabel.text = "NT$ \(productPrice)"
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CatalogToProductDetailSegue", sender: indexPath)
    }
    
    // MARK: Comform Collection View Delegate Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let productList = productList else {
            return 0
        }
        
        return productList.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let collectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CatalogCollectionViewCell",
                for: indexPath
            ) as? CatalogCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let currentProduct = productList.data[indexPath.row]
        
        setImage(for: collectionViewCell.productImageView, with: currentProduct.mainImage)
        
        collectionViewCell.productTitleLabel.text = currentProduct.title
        
        let productPrice = currentProduct.price
        collectionViewCell.productPriceLabel.text = "NT$ \(productPrice)"
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CatalogToProductDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? ProductDetailViewController else {
            print("Couldn't find the destination view controller.")
            return
        }
        
        guard let selectedIndexPath = sender as? IndexPath else {
            print("Convert type failure.")
            return
        }
        
        let selectedProduct = productList.data[selectedIndexPath.row]
        destinationViewController.currentProduct = selectedProduct
    }
    
    // MARK: Helper Methods
    
    func resetButtonTitleColor() {
        
        womenCatalogButton.setTitleColor(
            UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1),
            for: .normal)
        
        menCatalogButton.setTitleColor(
            UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1),
            for: .normal)
        
        accesoryCatalogButton.setTitleColor(
            UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1),
            for: .normal)
    }
    
    func reloadViewData() {
        
        stopRefreshingAndLoading()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            print("table reloaded")
        
            self.collectionView.reloadData()
            print("collection reloaded\n")
        }
    }
    
    func addPullDownRefresher() {
        
        tableView.es.addPullToRefresh {
            print("table refresh")
            
            switch self.currentCategory {
                
            case .women: self.womenProductList = nil
            case .men: self.menProductList = nil
            case .accessories: self.accessoriesProductList = nil
            }
            
            self.productListManager.requestProductList(for: self.currentCategory)
        }
        
        collectionView.es.addPullToRefresh {
            print("collection refresh")
            
            switch self.currentCategory {
                
            case .women: self.womenProductList = nil
            case .men: self.menProductList = nil
            case .accessories: self.accessoriesProductList = nil
            }
            
            self.productListManager.requestProductList(for: self.currentCategory)
        }
    }
    
    func addMoreDataLoader() {
        
        tableView.es.addInfiniteScrolling {
            print("table load more")
            if let productList = self.productList, let nextPage = productList.paging {
                self.productListManager.requestProductList(for: self.currentCategory, inPage: nextPage)
            } else {
                self.tableView.es.noticeNoMoreData()
                print("table no more data")
                self.collectionView.es.noticeNoMoreData()
                self.collectionView.footer?.alpha = 1.0
                print("collection no more data\n")
            }
        }
        
        collectionView.es.addInfiniteScrolling {
            print("collection load more")
            if let productList = self.productList, let nextPage = productList.paging {
                self.productListManager.requestProductList(for: self.currentCategory, inPage: nextPage)
            } else {
                self.collectionView.es.noticeNoMoreData()
                print("collection no more data")
                self.tableView.es.noticeNoMoreData()
                self.tableView.footer?.alpha = 1.0
                print("table no more data\n")
            }
        }
    }
    
    func stopRefreshingAndLoading() {
        
        DispatchQueue.main.async {
            
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
            
            self.collectionView.es.stopPullToRefresh()
            self.collectionView.es.stopLoadingMore()
        }
    }
    
    @IBAction func unwindToPreviousPage(_ segue: UIStoryboardSegue) {}
}
