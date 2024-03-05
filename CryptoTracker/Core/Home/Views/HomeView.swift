//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 24/02/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm :  HomeViewModel

    @State private var showPortfolio : Bool = false
    @State private var isPortfolioOpen : Bool = false
    @State private var showSettings : Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView : Bool = false
    var body: some View {
        ZStack {
            //Baclground Layer
            
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $isPortfolioOpen, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            //Content Layer
       
                VStack {
                    homeHeader
                 
                    StaticticsRow(showPortfolio: $showPortfolio)
                        
                    SearchBar(textfieldText: $vm.searchtext)

                     // title view
               
                    titleColumns
                  
                        if !showPortfolio {
                            listViewAllCoins
                                .transition(.move(edge: .leading))
                        }
                        if showPortfolio {
                            listViewPortfolioCoins
                                .transition(.move(edge: .trailing))
                        }
                       
                        Spacer()
                }
                .sheet(isPresented: $showSettings, content: {
                    SettingsView()
                })
            }
            .background(
            NavigationLink(
                destination: DetailLandingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: {
                    EmptyView()
                }
            )
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(HomeViewModel())
}

extension HomeView {
    private var homeHeader  : some View{
        HStack{
            CircleButton(iconName: showPortfolio ? "plus" : "info")
                .animation(.none , value: showPortfolio)
                .background(
                CircleButtonAnimation(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio {
                        isPortfolioOpen.toggle()
                    }else {
                        showSettings.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none , value: showPortfolio)
            Spacer()
            CircleButton(iconName: "chevron.compact.right")
                .rotationEffect(showPortfolio ? Angle(degrees: 180) : Angle(degrees: 0))
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    private var listViewAllCoins : some View {
        List{
            ForEach(vm.allCoins) { coin in
            
                    CoinRowView(coin: coin, showHoldings: false)
                        .listRowInsets(.init(top : 10 , leading: 0 , bottom: 10 , trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
            }
         }
        .listStyle(.plain)
        .padding(.horizontal , 0)
    
    }
    private var listViewPortfolioCoins : some View {
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldings: true)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
         }
        .listStyle(.plain)
        
    }
    
    private func segue (coin : CoinModel) {
        
        selectedCoin = coin
        showDetailView.toggle()
        print("\(showDetailView)")
    }
    private var titleColumns : some View {
        HStack {
            HStack(spacing : 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortSelection == .rank || vm.sortSelection == .rankReversed ?  1.0 : 0.0)
                    .rotationEffect(vm.sortSelection == .rank ? Angle(degrees: 0) : Angle(degrees: 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortSelection = vm.sortSelection == .rank ?  .rankReversed : .rank

                }
            }
         
            Spacer()
            if showPortfolio {
                HStack(spacing : 4) {
                    Text("Portfolio")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortSelection == .holdings || vm.sortSelection == .holdingReversed ?  1.0 : 0.0)
                        .rotationEffect(vm.sortSelection == .holdings ? Angle(degrees: 0) : Angle(degrees: 180))

                }
                .onTapGesture {
                    withAnimation {
                        vm.sortSelection = vm.sortSelection == .holdings ?  .holdingReversed : .holdings

                    }
                }
            }
            
            HStack {
                HStack(spacing : 4) {
                    Text("Price")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortSelection == .pricde || vm.sortSelection == .priceReversed ?  1.0 : 0.0)
                        .rotationEffect(vm.sortSelection == .pricde ? Angle(degrees: 0) : Angle(degrees: 180))

                }
                .onTapGesture {
                    withAnimation {
                        vm.sortSelection = vm.sortSelection == .pricde ?  .priceReversed : .pricde

                    }
                }
                    .frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .trailing)
                Button(action: {
                    withAnimation (.linear(duration: 2.0)) {
                        vm.reloadData()
                    }
                    
                }, label: {
                    Image(systemName: "goforward")
                })
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0) , anchor: .center)
            }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal , 20)
    }
}
