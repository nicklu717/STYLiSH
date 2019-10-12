//
//  HomeViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MarketManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var marketingHotsArray: [Hots] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        let marketManager = MarketManager()
        marketManager.delegate = self
        
        marketManager.getMarketingHots()
        
        // 加入 Pull-Down Refresher
        tableView.es.addPullToRefresh { marketManager.getMarketingHots() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Comform Delegation
    
    func manager(_ manager: MarketManager, didGet marketingHotsArray: [Hots]) {
        
        self.marketingHotsArray = marketingHotsArray
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }
    
    // MARK: Set Table View
    
    // Section 個數
    func numberOfSections(in tableView: UITableView) -> Int {
        return marketingHotsArray.count
    }
    
    // 客製化 Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 51))
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel.init(frame: CGRect.init(x: 16, y: 12, width: tableView.frame.size.width - 10, height: 27))
        label.text = marketingHotsArray[section].title
        label.textColor = UIColor.grayishBrown
        label.font = UIFont(name: "NotoSans-Medium", size: 18)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // Header 高度(放進客製化？)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
    // 每個 Section 的 Row 數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketingHotsArray[section].products.count
    }
    
    // 定義要放到 Row 裡的 Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let currentProduct = marketingHotsArray[indexPath.section].products[indexPath.row]
        
        switch isEvenNember(for: indexPath.row) {
        case true:
            
            guard
                let displayCellWithOneImage = tableView.dequeueReusableCell(
                    withIdentifier: "DisplayCellWithOneImage",
                    for: indexPath
                ) as? DisplayCellWithOneImage
            else {
                return UITableViewCell()
            }
            
            displayCellWithOneImage.selectionStyle = UITableViewCell.SelectionStyle.none
            
            setImage(for: displayCellWithOneImage.mainImageView, with: currentProduct.mainImage)
            
            displayCellWithOneImage.titleLabel.text = currentProduct.title
            displayCellWithOneImage.descriptionLabel.text = currentProduct.description
            
            return displayCellWithOneImage
            
        case false:
            guard
                let displayCellWithFourImage = tableView.dequeueReusableCell(
                    withIdentifier: "DisplayCellWithFourImage",
                    for: indexPath) as? DisplayCellWithFourImage
            else {
                return UITableViewCell()
            }
            
            displayCellWithFourImage.selectionStyle = UITableViewCell.SelectionStyle.none
            
            setImage(for: displayCellWithFourImage.leftImageView, with: currentProduct.images[0])
            setImage(for: displayCellWithFourImage.centerTopImageView, with: currentProduct.images[1])
            setImage(for: displayCellWithFourImage.centerBottomImageView, with: currentProduct.images[2])
            setImage(for: displayCellWithFourImage.rightImageView, with: currentProduct.images[3])
            
            displayCellWithFourImage.titleLabel.text = currentProduct.title
            displayCellWithFourImage.descriptionLabel.text = currentProduct.description
            
            return displayCellWithFourImage
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToProductDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedIndexPath = sender as? IndexPath else {
            print("Convert type failure.")
            return
        }
        
        guard let destinationViewController = segue.destination as? ProductDetailViewController else {
            print("Couldn't find the destination view controller.")
            return
        }
        
        let selectedProduct = marketingHotsArray[selectedIndexPath.section].products[selectedIndexPath.row]
        destinationViewController.currentProduct = selectedProduct
    }
    
    @IBAction func unwindToPreviousPage(_ segue: UIStoryboardSegue) {}
}
