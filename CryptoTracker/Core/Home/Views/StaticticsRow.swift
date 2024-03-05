//
//  StaticticsRow.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 28/02/24.
//

import SwiftUI

struct StaticticsRow: View {
    @EnvironmentObject private var vm : HomeViewModel
    @Binding var showPortfolio : Bool
  
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width ,alignment: showPortfolio ? .trailing : .leading)

    }
}

#Preview {
    StaticticsRow(showPortfolio: .constant(true))
}
