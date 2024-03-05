//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 24/02/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin : CoinModel
    let showHoldings : Bool
    var body: some View {
      
        HStack (spacing: 0){
           leftColumn
            Spacer()
            if showHoldings {
                middleColumn
            }
         //   Spacer()
           rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}

#Preview {

        CoinRowView(coin : DeveloperPreview.instance.coin, showHoldings: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
}


//extension for the code

extension CoinRowView {
    
    private var leftColumn : some View {
        HStack(spacing : 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30 , height:  30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading , 10)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    
    private var middleColumn : some View {
        VStack(alignment : .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
    }
    private var rightColumn : some View {
        VStack(alignment : .trailing){
            Text("\(coin.currentPrice.asCurrencyWith6Decimals() )")
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green:
                        Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
    }
}
