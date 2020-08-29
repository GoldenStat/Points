//
//  ScoreHistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 28.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScoreHistoryView: View {
    
    var header: [ String ] = History.Sample.names.shuffled()
    var points: [ [ Int ] ] = History.Sample.points
    
    var sumLine: [ Int ] {
        points.map { $0.reduce(0) {$0 + $1} }
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            HStack {
                ForEach(History.Sample.names, id: \.self) { text in
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
                        }
                    }
                    Spacer()
                }
            }
            
            Rectangle()
                .frame(height: 2)
            
            HStack {
                Spacer()
                ForEach(sumLine, id: \.self) { sum in
                    Text(sum.description)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .frame(maxHeight: 500)
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreHistoryView()
    }
}
