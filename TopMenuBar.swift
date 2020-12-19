//
//  TopMenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 18.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TopMenuBar : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        ZStack {
            Text(settings.rule.description)
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                Spacer()
                ZStack {
                    if settings.timerRoundStarted {
                        CountdownView(totalTimeInterval: settings.timeIntervalToCountRound - settings.timeIntervalToCountPoints,
                                      color: Color.points)
                            .aspectRatio(contentMode: .fit)
                    }
                    if settings.timerPointsStarted {
                        CountdownView(totalTimeInterval: settings.timeIntervalToCountPoints,
                                      color: Color.pointbuffer)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding()
            }
            .frame(width: 360, height: 40)
        }
    }
}

struct TopMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuBar()
            .environmentObject(GameSettings())
            .previewLayout(.fixed(width: 380, height: 40))
    }
}
