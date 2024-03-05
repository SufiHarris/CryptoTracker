//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 11/03/24.
//

import SwiftUI

struct ChartView: View {
    private  let data : [Double]
    private let maxY : Double
    private let minY : Double
    private let lineColor : Color
    private let firstDate : Date
    private let lastDate : Date
    
    @State private var percentage: CGFloat = 0
    
    init (coin : CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        lastDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        firstDate = lastDate.addingTimeInterval(-7*24*60*60)
     }
    
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(dividerView)
                .overlay (
                    chartXaxisValue.padding(.horizontal ,4)
                    ,alignment : .leading
                )
            chartDateLabel
                .padding(.horizontal,4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin : DeveloperPreview.instance.coin)
}

extension ChartView {
    private var chartView : some View {
        GeometryReader { geometry in
            Path { path in
                for index   in data.indices {
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis  = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    if  index == 0 {
                        path.move(to: CGPoint(x: xPosition, y : yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            
            }
            .trim(from : 0  , to : percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2 , lineCap: .round ,
                                                  lineJoin: .round))
            .shadow(color: lineColor,  radius: 10 ,x : 0 , y: 10)
            .shadow(color: lineColor.opacity(0.5),  radius: 10 ,x : 0 , y: 20)
            .shadow(color: lineColor.opacity(0.2),  radius: 10 ,x : 0 , y: 30)
            .shadow(color: lineColor.opacity(0.1),  radius: 10 ,x : 0 , y: 40)
        }
    }
    private var dividerView : some View {
        VStack(content: {
         Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        })
        
    }
    
    private var chartXaxisValue : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var chartDateLabel : some View {
        HStack(content: {
            Text(firstDate.asShortDateString())
            Spacer()
            Text(lastDate.asShortDateString())
        })
    }
}
