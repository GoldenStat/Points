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
    
    private var players : Players { settings.players }
    
    private var historyMode : HistoryView.Mode {
        settings.showSumsInHistory ? .perRow : .total
    }
    
    var showBuffer = false // during update phase
    private var history: History { settings.history }
    
    var body: some View {
        VStack {
            
            // Sum toggle button
            SumButtonRow(toggle: $settings.showSumsInHistory)
                .disabled(history.isEmpty)
                .padding()
            
            HistoryView(history: settings.history,
                        playerNames: players.names,
                        showHistoryBuffer: showBuffer,
                        mode:  historyMode)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

                Spacer()
        }
        .foregroundColor(.text)
        .background(Color.boardbgColor)
        .padding(.bottom)
    }
    
}

/// a slighter bigger divider... only for horizontal divisions, though
struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

fileprivate struct SumButtonRow: View {
    
    @Binding var toggle: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Button() {
                toggle.toggle()
            } label: {
                Image(systemName: "sum")
            }
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScoreHistoryView()
            .padding()
            .environmentObject(GameSettings())
            .environmentObject(DebugLog())
            .colorScheme(.dark)
    }
}
