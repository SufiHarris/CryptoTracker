//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 29/02/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var vm : HomeViewModel
    @State var selectedCoin : CoinModel? = nil
    @State var portfolioCoinAmount : String = ""
    @State var showCheckmark : Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment : .leading , spacing : 0) {
                    SearchBar(textfieldText: $vm.searchtext)
                    coinLogoList
                    
                    if selectedCoin != nil {
                 portfolioInputSection
                    }
                }
            }
            .navigationTitle("Portfolio")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                  XmarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingToolbarButtons
                }
            }
            .onChange(of: vm.searchtext) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }

    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}

extension PortfolioView {
    
    private var coinLogoList : some View {
        ScrollView(.horizontal , showsIndicators: true) {
            LazyHStack(spacing: 10, content: {
                ForEach( vm.searchtext.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .cornerRadius(7)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10 )
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear)
                                .cornerRadius(7)
                        )
                }
            })
        }
        .padding(.vertical , 4)
        .padding(.leading)
    }
    
    private func updateSelectedCoin (coin : CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}) ,
           let amount = portfolioCoin.currentHoldings {
            portfolioCoinAmount = "\(amount)"
        }else {
            portfolioCoinAmount = ""
        }
    }
    
    private func getCurrentValue () -> Double {
        if  let quantity = Double(portfolioCoinAmount) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection : some View {
        VStack (spacing : 10){
            HStack {
                Text("Current price of the \(selectedCoin?.symbol.uppercased() ?? " ") :")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount in your portfolio :")
                Spacer()
                TextField("EX : 1.4", text: $portfolioCoinAmount)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value : ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding(20)
        .font(.headline)
    }
    
    private var trailingToolbarButtons : some View {
        HStack (spacing : 10){
            Image(systemName: "checkmark")
                .opacity(showCheckmark  ? 1.0 : 0.0)
            Button(action: {
                
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(portfolioCoinAmount)) ? 1.0 : 0.0
            )
        }
    }
    private func saveButtonPressed () {
        
        guard let coin = selectedCoin ,
              let amount = Double(portfolioCoinAmount)
             else { return }
        
        //Save to portfolio
        vm.updateortfolio(coin: coin, amount: amount)
        //Show checkmark
        withAnimation {
            showCheckmark.toggle()
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation (.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin () {
        showCheckmark.toggle()
        selectedCoin = nil
        portfolioCoinAmount = ""
    }
}
