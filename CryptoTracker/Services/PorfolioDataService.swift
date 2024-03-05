//
//  PorfolioDataService.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 04/03/24.
//

import Foundation
import CoreData

class PorfolioDataService {
    
    private let container : NSPersistentContainer
    private let entityName : String = "PortfolioEntity"
    
    @Published var savedData : [PortfolioEntity] = []
    
    init () {
        
        container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores { _,error in
            if let error = error {
                print("Error while persisting data \(error)")
            }
        }
        getPortfolio()
    }
    // MARK: PUBLIC
    public func updatePortfolio (coin :CoinModel , amount : Double ){
        if let entity = savedData.first(where: {$0.coinId == coin.id}) {
            if amount > 0 {
                updateData(entity: entity, amount: amount)
            }else {
                deleteEntity(entity: entity)
            }
        }else {
            addCoin(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
   private func getPortfolio () {
        
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
          try  savedData = container.viewContext.fetch(request)
        }catch let error {
            print("Error while fetching request \(error.localizedDescription)")
        }
    }
    private func addCoin (coin : CoinModel  , amount : Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.amount = amount
        entity.coinId = coin.id
        applyChanges()
        
    }
    
    private func updateData (entity : PortfolioEntity , amount :Double) {
        entity.amount = amount
        applyChanges()
    }
    private func deleteEntity (entity : PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func saveData () {
        do {
            try container.viewContext.save()
        }catch let error {
            print("Error while saving the data. \(error.localizedDescription)")
        }
    }
    private func applyChanges () {
        saveData()
        getPortfolio()
    }
}
