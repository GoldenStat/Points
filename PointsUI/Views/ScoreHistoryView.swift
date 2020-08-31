//
//  ScoreHistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 28.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScoreHistoryView: View {
    @EnvironmentObject var settings: GameSettings

    var header: [ String ] { settings.playerNames }
    var points: [ [ Int ] ] { settings.playerScores }
    
    var sumLine: [ Int ] {
        points.map { $0.reduce(0) {$0 + $1} }
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            HStack {
                ForEach(header, id: \.self) { text in
                    Text(text)
                }
            }
            
            Divider()
            
            HStack {
                Spacer()
                ForEach(points, id: \.self) { playerScores in
                    VStack {
                        ForEach(playerScores, id: \.self) { point in
                            Text(point.description)
                                .frame(width: numberCellWidth)
                        }
                    }
                    Spacer()
                }
            }
            
            BoldDivider()
            
            HStack {
                Spacer()
                ForEach(sumLine, id: \.self) { sum in
                    Text(sum.description)
                        .fontWeight(.bold)
                        .frame(width: numberCellWidth)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .frame(maxHeight: historyViewHeight)
    }
    
    let numberCellWidth : CGFloat = 60.0
    let historyViewHeight : CGFloat = 500.0
}

struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreHistoryView()
            .environmentObject(GameSettings())
    }
}
