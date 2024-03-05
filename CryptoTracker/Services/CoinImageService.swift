//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 27/02/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image : UIImage? = nil
    private  var imageSubscription : AnyCancellable?
    private var coin : CoinModel
    private let  fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private var imageName : String
    
    init (coin : CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    private func getCoinImage () {
        if let  savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
        }else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url  = URL(string: coin.image) else { return }
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data) 
            })
            .sink(receiveCompletion:
                    NetworkManager.handleCompletion, receiveValue: {[weak self] (returnedImage) in
                guard let self = self , let downloadImage = returnedImage else { return }
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
