//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 08/03/24.
//

import Foundation
import Combine
class DetailViewModel : ObservableObject {
    @Published var overviewStatistics   : [StatisticModel] = []
    @Published var additionalStatistics : [StatisticModel] = []
    @Published var coinDescription : String? = nil
    @Published var websiteURL : String? = nil
    @Published var redditURL : String? = nil
    
    @Published var coin : CoinModel
    private let coinDetailService  : CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    init( coin : CoinModel) {
        self.coin   = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.getData()
    }
    
    private func getData () {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink {[weak self] (returnedDetails) in
                self?.overviewStatistics = returnedDetails.overview
                self?.additionalStatistics = returnedDetails.aditional
            }
            .store(in: &cancellable)
        
        coinDetailService.$coinDetails
            .sink {[weak self] (returnedCoins) in
                self?.coinDescription = returnedCoins?.readableDescription?.removeHtmlOccurances
                self?.websiteURL = returnedCoins?.links?.homepage?.first
                self?.redditURL = returnedCoins?.links?.subredditURL
            }
            .store(in: &cancellable)
        
    }

    
    private func mapDataToStatistics(  coinDetailModel : CoinDetailModel?  ,coinModel : CoinModel) -> (overview : [StatisticModel]  ,aditional : [StatisticModel]) {
        let overViewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)

        
        return (overViewArray , additionalArray)
    }
    private func createOverviewArray (coinModel : CoinModel) -> [StatisticModel] {
        let price  = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        let overViewArray : [StatisticModel] = [
        priceStat , marketCapStat , rankStat , volumeStat
        ]
        return overViewArray
    }
    
    private func createAdditionalArray (coinModel: CoinModel , coinDetailModel : CoinDetailModel?) -> [StatisticModel] {
        
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange , percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2  = coinModel.marketCapChangePercentage24H
        let marketCapStat2 = StatisticModel(title: "24h Market Cap", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
         let additionalArray : [StatisticModel] = [
            highStat , lowStat , priceChangeStat , marketCapStat2 , blockStat , hashingStat
        ]
        return additionalArray
    }
}
