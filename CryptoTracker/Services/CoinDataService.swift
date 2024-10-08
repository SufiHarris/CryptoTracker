//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 27/02/24.
//

import Foundation
import SwiftUI
import Combine

class CoinDataService {
    @Published var allCoins : [CoinModel] = []
 //   @Binding var isLoaded : Bool?
    var coinSubscription : AnyCancellable?
    
    init () {
        getData()
       // isLoaded = isLoad
    }
    public func getData () {
        guard let url  = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
           
            .sink(receiveCompletion:
                    NetworkManager.handleCompletion, receiveValue: {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })

    }
}
