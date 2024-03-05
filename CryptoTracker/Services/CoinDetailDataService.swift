//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 08/03/24.
//

import Foundation
import Foundation
import SwiftUI
import Combine

class CoinDetailDataService {
    @Published var coinDetails : CoinDetailModel? = nil
    var coinDetailSubscription : AnyCancellable?
    let coin : CoinModel

    init (coin : CoinModel) {
        self.coin = coin
        getData()
       // isLoaded = isLoad
    }
    public func getData () {
        guard let url  = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
           
            .sink(receiveCompletion:
                    NetworkManager.handleCompletion, receiveValue: {[weak self] (returnedCoinsDetails) in
                self?.coinDetails = returnedCoinsDetails
                self?.coinDetailSubscription?.cancel()
            })

    }
}
