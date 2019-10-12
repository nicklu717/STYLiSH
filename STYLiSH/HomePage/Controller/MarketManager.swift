//
//  MarketManager.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

protocol MarketManagerDelegate: class {
    
    func manager(_ manager: MarketManager, didGet marketingHotsArray: [Hots])
    
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    
    weak var delegate: MarketManagerDelegate?
    
    func getMarketingHots() {
        
        let marketingHotsEndpoint = MarketingHotsAPI.Endpoint.marketingHots.url
        
        let task = URLSession.shared.dataTask(with: marketingHotsEndpoint) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    self.delegate?.manager(self, didFailWith: error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let marketingHots = try decoder.decode(MarketingHots.self, from: data)
                if let marketingHotsError = marketingHots.error as? Error {
                    self.delegate?.manager(self, didFailWith: marketingHotsError)
                }
                self.delegate?.manager(self, didGet: marketingHots.data)
            } catch {
                self.delegate?.manager(self, didFailWith: error)
            }
        }
        task.resume()
    }
}
