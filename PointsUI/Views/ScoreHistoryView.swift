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
    var history: History { settings.history }
    
    var sumLine: [ Int ] {
        history.states.last?.scores ?? [Int](repeating: 0, count: settings.numberOfPlayers)
    }

    /// reduce all scores in history states to simple scores
    var scoresInSumMode: [[ Int ]] {
        var allScores: [[Int]] = [[]]
        
        for state in history.states {
            var scores: [Int] = []
            for score in state.scores {
                scores.append(score)
            }
            allScores.append(scores)
        }
        
        return allScores
    }

    /// reduce all scores in history states to how score differences
    var scoresInIndividualMode: [[ Int ]] {
        var allScores: [[Int]] = [[]]
        
        for state in history.states {
            var scores: [Int] = []
            for score in state.scores {
                scores.append(score)
            }
            allScores.append(scores)
        }
        
        return allScores
    }
    
    var scoresForHistory: [[ Int ]] {
        showSums ? scoresInIndividualMode : scoresInSumMode
    }

    var isHistoryEmpty: Bool { history.states.isEmpty }
    @State var showSums = false
    
    var body: some View {
        VStack(alignment: HorizontalAlignment/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            HStack {
                Spacer()
            
                Button() {
                    showSums.toggle()
                } label: {
                    Image(systemName: "sum")
                }
                .disabled(isHistoryEmpty)
            }
            .padding()

            HistoryTableRowView(content: header)
            
            Divider()
            
            if isHistoryEmpty {
                
                HistoryTableRowView(content: [String](repeating: "0", count: header.count))
                
            } else {
                VStack {
                    ForEach(scoresForHistory, id: \.self) { scores in
                        HistoryTableRowView(content: scores.map {$0.description})
                    }
                }
                
                if showSums {
                    BoldDivider()
                    
                    HStack {
                        ForEach(sumLine, id: \.self) { sum in
                            HistoryTableCellView(content: sum.description, bold: true)
                        }
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .frame(maxHeight: historyViewHeight)
    }
    
    let historyViewHeight : CGFloat = 500.0
}

struct HistoryTableRowView: View {

    let content: [TableCellContent]
    
    var body: some View {
        HStack {
            ForEach(content, id: \.self) { cell in
                HistoryTableCellView(content: cell)
            }
        }
    }
}

typealias TableCellContent = String

struct HistoryTableCellView: View {
    let numberCellWidth : CGFloat = 60.0

    let content: TableCellContent
    var bold: Bool = false
    
    var body: some View {
        Text(content)
            .fontWeight(bold ? .bold : .none)
            .frame(width: numberCellWidth)
    }
}

struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

struct HistorySampleView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
            ScoreHistoryView()
            Button("Add New Round") {
                addScoresToHistory()
            }
        }
    }
    
    func addScoresToHistory() {
        for player in settings.players.items {
            let sampleScore = Int.random(in: 0 ... 6)
            print ("Adding score \(sampleScore) to Player <\(player.name)>")
            player.add(score: sampleScore)
            player.saveScore()
        }
        
        settings.history.save(state: GameState(players: settings.players.data))
        
        print("adding <\(settings.history.states.last!.scores.map {$0.description})>")
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySampleView()
            .environmentObject(GameSettings())
    }
}
