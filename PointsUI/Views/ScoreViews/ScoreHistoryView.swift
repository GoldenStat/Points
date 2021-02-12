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
    
    @State var showSums = false
    private var historyMode : HistoryView.Mode {
        showSums ? .perRow : .total
    }
    private var history: History { settings.history }
    
    var body: some View {
        VStack {
            
            // Sum toggle button
            SumButton(toggle: $showSums)
                .disabled(history.isEmpty)
                .padding()
            
            HistoryView(history: settings.history, playerNames: settings.playerNames, mode:  historyMode)
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

/// this view is used in two places for adding test values to the settings' history property for testing
struct HistoryScoreGeneratorButton: View {
    @EnvironmentObject var settings: GameSettings
    
    var startScore: Int = 0
    var endScore: Int = 3
    
    var body: some View {
        HStack {
            Button() {
                addScoresToHistory()
            } label: {
                Text("Add New Round")
                    .fontWeight(.bold)
                    .foregroundColor(.text)
            }
            .padding()
            .background(Color.boardbgColor
                            .cornerRadius(20)
            )
            .padding()
        }
    }
    
    @EnvironmentObject var logger: DebugLog
    
    var history: History { settings.history }
    
    private func addScoresToHistory() {
        
        if history.isBuffered {
            history.save()
        } else {
            let players = settings.players
            
            var messages : [String] = []
            for player in players.items {
                let sampleScore = Int.random(in: startScore ... endScore)
                
                player.add(score: sampleScore)
                player.saveScore()
                
                messages.append(player.description)
            }
            
            logger.log(msg: messages.joined(separator: " | "))
            
            let newState = GameState(players: players.data)
            logger.log(msg: newState.description)
            
            history.add(state: newState)
        }
        
        settings.objectWillChange.send()
    }
}

struct HistoryDebugView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    HistoryScoreGeneratorButton()
                    Button(action: { settings.history.undo()
                        settings.objectWillChange.send()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    Button(action: { settings.history.redo()
                        settings.objectWillChange.send()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                    HistorySymbolRow()
                }
                ScoreHistoryView()
                    .emphasizeShape(cornerRadius: 16.0)
                    .transition(.opacity)
                    .padding()
            }
        }
    }
}

fileprivate struct SumButton: View {
    
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
        HistoryDebugView()
            .padding()
            .environmentObject(GameSettings())
            .environmentObject(DebugLog())
            .colorScheme(.dark)
    }
}
