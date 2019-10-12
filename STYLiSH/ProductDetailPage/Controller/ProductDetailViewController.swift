//
//  ProductDetailViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/18.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentProduct: Product!
    
    let screenSize = UIScreen.main.bounds
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var addToCartSuperView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add Images to Banner
        bannerScrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width * 4/3)
        
        mainImageView.frame = bannerScrollView.frame
        
        setImage(for: mainImageView, with: currentProduct.mainImage)

        bannerScrollView.contentSize = CGSize(width: mainImageView.frame.width, height: mainImageView.frame.height)
        
        var previousImageView = mainImageView!

        for image in currentProduct.images {

            let imageView = UIImageView()
            imageView.frame.origin = CGPoint(
                x: previousImageView.frame.origin.x + previousImageView.frame.width,
                y: previousImageView.frame.origin.y)
            imageView.frame.size = mainImageView.frame.size
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            setImage(for: imageView, with: image)
            bannerScrollView.addSubview(imageView)

            bannerScrollView.contentSize.width += imageView.frame.width
            previousImageView = imageView
        }
        
        addTopBorder(for: addToCartSuperView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    // Table View Delegate Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Table View Data Source Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    // swiftlint:disable cyclomatic_complexity function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard
                let titleCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewTitleCell",
                    for: indexPath
                ) as? ProductDetailTableViewTitleCell
            else {
                return UITableViewCell()
            }
            
            titleCell.titleLable.text = currentProduct.title
            titleCell.IDLabel.text = "\(currentProduct.id)"
            titleCell.priceLabel.text = "NT$ \(currentProduct.price)"
            
            return titleCell
            
        case 1:
            guard
                let storyCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewStoryCell",
                    for: indexPath
                ) as? ProductDetailTableViewStoryCell
            else {
                return UITableViewCell()
            }
            
            storyCell.storyLabel.text = currentProduct.story
            
            return storyCell
            
        case 2:
            guard
                let colorCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewColorCell",
                    for: indexPath
                ) as? ProductDetailTableViewColorCell
            else {
                return UITableViewCell()
            }
            
            var colorCubeOriginX = colorCell.colorTitleLabel.frame.origin.x + colorCell.colorTitleLabel.frame.width + 27
            let colorCubeOriginY = colorCell.colorTitleLabel.frame.origin.y
            
            for color in currentProduct.colors {
                
                let colorCube = UIView(frame: CGRect(x: colorCubeOriginX, y: colorCubeOriginY, width: 18, height: 18))
                colorCube.backgroundColor = UIColor(hex: color.code)
                
                colorCell.contentView.addSubview(colorCube)
                
                colorCubeOriginX += colorCube.frame.width + 8
            }
            
            return colorCell
            
        case 3:
            guard
                let sizeCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            
            sizeCell.infoTitleLable.text = NSLocalizedString("尺寸", comment: "")
            
            if let smallestSize = currentProduct.sizes.first, let largestSize = currentProduct.sizes.last {
                
                if smallestSize == largestSize {
                    sizeCell.infoContentLabel.text = "\(smallestSize)"
                } else {
                    sizeCell.infoContentLabel.text = "\(smallestSize) - \(largestSize)"
                }
                
            } else {
                sizeCell.infoContentLabel.text = "No Data"
            }
            
            return sizeCell
            
        case 4:
            guard
                let stockCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            
            stockCell.infoTitleLable.text = NSLocalizedString("庫存", comment: "")
            
            var stock = 0
            for variant in currentProduct.variants {
                stock += variant.stock
            }
                
            stockCell.infoContentLabel.text = "\(stock)"
            
            return stockCell
            
        case 5:
            guard
                let textureCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            
            textureCell.infoTitleLable.text = NSLocalizedString("材質", comment: "")
            textureCell.infoContentLabel.text = currentProduct.texture
            
            return textureCell
            
        case 6:
            guard
                let washCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            
            washCell.infoTitleLable.text = NSLocalizedString("洗滌", comment: "")
            washCell.infoContentLabel.text = currentProduct.wash
            
            return washCell
            
        case 7:
            guard
                let placeCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            
            placeCell.infoTitleLable.text = NSLocalizedString("產地", comment: "")
            placeCell.infoContentLabel.text = currentProduct.place
            
            return placeCell
            
        case 8:
            guard
                let noteCell = tableView.dequeueReusableCell(
                    withIdentifier: "ProductDetailTableViewInfoCell",
                    for: indexPath
                ) as? ProductDetailTableViewInfoCell
            else {
                return UITableViewCell()
            }
            noteCell.infoTitleLable.text = NSLocalizedString("備註", comment: "")
            noteCell.infoContentLabel.text = currentProduct.note
            
            return noteCell
            
        default:
            return UITableViewCell()
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
    
    @IBAction func addToCart() {
        performSegue(withIdentifier: "PresentAddToCartSegue", sender: currentProduct)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? AddToCartViewController else {
            print("Couldn't find AddToCartVC.")
            return
        }
        
        guard let currentProduct = sender as? Product else {
            print("Couldn't downcast sender as product.")
            return
        }
        
        destinationViewController.currentProduct = currentProduct
    }
}
