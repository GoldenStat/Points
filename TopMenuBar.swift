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
        HStack {
            Text(settings.rule.description)
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                if settings.timerPointsStarted {
                    CountdownView(totalTimeInterval: settings.updateTimeIntervalToRegisterPoints,
                                  color: Color.pointbuffer)
                    
                }
                if settings.timerHistoryStarted {
                    CountdownView(totalTimeInterval: settings.timeIntervalToCountAsRound,
                                  color: Color.points)
                }
            }
        }
    }
}

struct TopMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuBar()
            .environmentObject(GameSettings())
            .previewLayout(.fixed(width: 480, height: 100))
    }
}
