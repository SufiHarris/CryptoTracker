//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 29/02/24.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData : MarketDataModel? = nil
    var marketDataSubscription : AnyCancellable?
    
    init () {
        getData()
    }
    public func getData () {
        guard let url  = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
           
            .sink(receiveCompletion:
                    NetworkManager.handleCompletion, receiveValue: {[weak self] (returnedData) in
                self?.marketData = returnedData.data
                self?.marketDataSubscription?.cancel()
            })

    }
}
