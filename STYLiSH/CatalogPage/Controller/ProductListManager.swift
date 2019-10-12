//
//  ProductListManager.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Alamofire

protocol ProductListManagerDelegate: class {
    
    func manager(_ manager: ProductListManager, didGet newProductListForCurrentCategory: ProductList)
    
    func manager(_ manager: ProductListManager, didFailWith error: Error?)
}

class ProductListManager {
    
    weak var delegate: ProductListManagerDelegate?
    
    func requestProductList(for category: CurrentCategory, inPage paging: Int = 0) {
        
        // Finish Request URL
        var endPointURLComponent: URLComponents
        
        switch category {
            
        case .women: endPointURLComponent = ProductListAPI.EndPoint.women.urlComponent
        case .men: endPointURLComponent = ProductListAPI.EndPoint.men.urlComponent
        case .accessories: endPointURLComponent = ProductListAPI.EndPoint.accessories.urlComponent
        }
        
        endPointURLComponent.queryItems = [URLQueryItem(name: "paging", value: String(paging))]

        guard let requestURL = endPointURLComponent.url else {
            print("Error: Invalid URL")
            return
        }
        print("URL: \(requestURL)")
        
        // Request Data
        
        AF.request(requestURL).responseJSON { response in
            
            let decoder = JSONDecoder()
            
            guard let newProductListDataForCurrentCategory = response.data else {
                print("Error: Data Parsing")
                self.delegate?.manager(self, didFailWith: response.error)
                return
            }
            
            do {
                let newProductListForCurrentCategory =
                    try decoder.decode(ProductList.self, from: newProductListDataForCurrentCategory)
                self.delegate?.manager(self, didGet: newProductListForCurrentCategory)
            } catch {
                print("Error: Data Decoding")
                self.delegate?.manager(self, didFailWith: response.error)
            }
        }
    }
    
}
