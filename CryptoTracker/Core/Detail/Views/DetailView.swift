//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 08/03/24.
//

import SwiftUI

struct DetailLandingView : View {
    @Binding var coin : CoinModel?
  
    
    var body: some View {
        ZStack {
            if let coin = coin {
                //Text("\(coin.currentPrice)")
                 DetailView(coin: coin)
               // DetailView(coin: coin)
            }else {
             Text("Not dopne")
            }
            
        }
    }
}


struct DetailView: View {
    @StateObject var vm : DetailViewModel
    @State var showFullDescription: Bool = false
    private let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing : CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
       
    }
    var body: some View {
        ScrollView {
            VStack {
                    ChartView(coin: vm.coin)
                    .padding(.vertical)
                    VStack(spacing : 20 , content: {
                    overviewTitle
                    Divider()
                    descriptionView
                    overviewGrid
                        Divider()
                    additionalTitle
                    additionalGrid
                    linkView
                    
                })
            }
        
            .padding()
            
        }   
        .navigationTitle("\(vm.coin.name)")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                HStack(content: {
                    Text("\(vm.coin.symbol.uppercased())")
                        .font(.headline)
                        .foregroundStyle(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                })
            })
        }
    }
}

#Preview {
    NavigationStack {
        DetailLandingView(coin:.constant(DeveloperPreview.instance.coin) )
    }
}

extension DetailView {
    private var overviewTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity , alignment: .leading)
    }
    private var additionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity , alignment: .leading)
    }
    private var overviewGrid : some View {
        LazyVGrid(columns: columns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatistics) {stat  in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var additionalGrid : some View {
        LazyVGrid(columns: columns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
           
            ForEach(vm.additionalStatistics) {  stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var descriptionView : some View {
        ZStack {
            if let coinDescription = vm.coinDescription ,
               !coinDescription.isEmpty {
                VStack(alignment : .leading) {
                    
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                        
                    }, label: {
                        HStack {
                            Text(showFullDescription ? "Less" : "Read more")
                            Image(systemName:"chevron.up")
                                .rotationEffect(Angle(degrees: showFullDescription ? 0 : 180))
                        }
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.blue)
                    })
                }
           
            }
        }
    }
    private var linkView : some View {
        VStack (alignment : .leading , spacing : 20) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString){
                Link("Website", destination: url)
            }
            if let redditURL = vm.redditURL ,
               let url = URL(string: redditURL) {
                Link ("Reddit" , destination: url)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity , alignment : .leading)
        .font(.headline)
    }
}
