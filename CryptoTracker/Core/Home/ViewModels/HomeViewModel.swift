//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 26/02/24.
//

import Foundation
import Combine


class HomeViewModel : ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var searchtext : String = ""
    @Published var  statistics : [StatisticModel] = []
    @Published var isLoading : Bool = false
    @Published var sortSelection : sortOption = .holdings
    
    
    private let coinDataService = CoinDataService()
    private  var cancellables = Set<AnyCancellable>()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PorfolioDataService()
    
    enum sortOption {
        case rank , rankReversed , holdings , holdingReversed , pricde , priceReversed
    }
    init() {
     getSubscribers()
     
    }
    private func getSubscribers () {
        $searchtext
            .combineLatest(coinDataService.$allCoins , $sortSelection)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedData)
            .map (mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (receivedCoins) in
                guard let self = self else { return }
                self.portfolioCoins =   self.sortPortfolioCoinsIfNeeded(coins: receivedCoins)
            }
            .store(in: &cancellables)
          
        marketDataService.$marketData
            .map(getFilteredGlobalData)
            .sink { [weak self] (returnedData) in
                self?.statistics = returnedData
            
                self?.isLoading = false
            }
            .store(in: &cancellables)

     }
    
    public func reloadData() {
        isLoading = true
        coinDataService.getData()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func mapAllCoinsToPortfolioCoins (coinList : [CoinModel] , portfolioEntities : [PortfolioEntity]) -> [CoinModel] {
    coinList.compactMap {(coin) -> CoinModel? in
        guard let entity = portfolioEntities.first(where: {$0.coinId == coin.id}) else {
            return nil
        }
        return coin.updateHoldings(amount: entity.amount )
        
    }
    }
    
    private func filterAndSortCoins (text : String , coins : [CoinModel] , sort : sortOption) -> [CoinModel] {
        
           var updatedCoins = getFilteredArray(text: text, coins: coins)
            sortCoins(sort: sort, coins: &updatedCoins)
           return updatedCoins
    }
    
    private func getFilteredArray (text : String , coins : [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowecasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowecasedText) ||
            coin.symbol.lowercased().contains(lowecasedText) ||
            coin.id.lowercased().contains(lowecasedText)
        }
    }
    
    private func sortCoins(sort : sortOption , coins : inout [CoinModel]) {
        switch sort {
        case .rank , .holdings :
            return coins.sort { coin1, coin2 in
                 coin1.rank < coin2.rank
            }
            
        case .rankReversed , .holdingReversed:
             coins.sort { $0.rank > $1.rank  }
            
        case .pricde :
             coins.sort (by: { $0.currentPrice > $1.currentPrice } )
        case .priceReversed :
             coins.sort (by: { $0.currentPrice < $1.currentPrice } )
     
        }
    }
    
    private func sortPortfolioCoinsIfNeeded (coins : [CoinModel]) -> [CoinModel] {
        
        switch sortSelection {
        case.holdings :
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        case.holdingReversed :
           return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        default :
            return coins
        }
    }
    func updateortfolio (coin : CoinModel , amount : Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func getFilteredGlobalData (marketDataModel : MarketDataModel?) -> [StatisticModel] {
        var stat : [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stat
        }

        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue =
        portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue =  currentValue / (1 + percentChange) * 100
            return previousValue
        }
        .reduce(0, +)
        
        let percentage = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentage)
        
        stat.append(contentsOf:
        [marketCap , volume , btcDominance , portfolio]
        )
        return stat
    }
}
