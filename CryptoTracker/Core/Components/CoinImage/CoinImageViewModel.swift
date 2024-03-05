//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 27/02/24.
//

import Foundation
import SwiftUI
import Combine
class CoinImageViewModel : ObservableObject {
    @Published var image : UIImage?
    @Published var isLoading : Bool = true
    private var dataService : CoinImageService
    private var coin : CoinModel
    private var cancellables = Set<AnyCancellable>()
    init(coin : CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscriber()
    }
    private func addSubscriber() {
        dataService.$image
            .sink {[weak self] (_) in
                self?.isLoading  = false
            } receiveValue: {[weak self] (returnedImage) in
                self?.image  = returnedImage
            }
            .store(in: &cancellables)
    }
}
