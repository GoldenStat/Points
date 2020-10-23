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
    
//    private var header: [ String ] { settings.playerNames }
    private var header: [ String ] { ["Alexander", "Alexander" ] }
    private var numberOfColumns: Int { header.count }
    private var history: History { settings.history }
    
    private var sumLine: [ Int ] {
        history.buffer?.scores ??
        history.states.last?.scores ?? [Int](repeating: 0, count: settings.numberOfPlayers)
    }

    /// reduce all scores in history states to simple scores
    /// just extract the scores from the state as they are already the sums
    private var scoresInSumMode: [[ Int ]] {
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

    private var allStates: [GameState] {
        var copyOfHistoryState: [GameState] = history.states
        
        if let buffer = history.buffer {
            copyOfHistoryState.append(buffer)
        }
        
        return copyOfHistoryState
    }
    
    private var nullValues : [ Int ] { [Int](repeating: 0, count: numberOfColumns) }
    
    /// reduce all scores in history states to how score differences
    private var scoresInIndividualMode: [[ Int ]] {
        var allScores: [[Int]] = [[]]
        var scoresSoFar = nullValues
        
        for state in allStates {
            var scores: [Int] = []
            for index in 0 ..< numberOfColumns {
                let diffScore = state.scores[index] - scoresSoFar[index]
                scores.append(diffScore)
            }
            allScores.append(scores)
            scoresSoFar = state.scores
        }
        
        return allScores
    }
    
    private var scoresForHistory: [[ Int ]] {
        showSums ? scoresInIndividualMode : scoresInSumMode
    }

    private var isHistoryEmpty: Bool { history.states.isEmpty && history.buffer == nil }
    
    @State var showSums = false
    
    var body: some View {
        VStack() {
            
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
                
                HistoryTableRowView(content: [String](repeating: "0", count: numberOfColumns))
                
            } else {
                ScrollView(.vertical) {
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
                        .foregroundColor(history.buffer == nil ? .black : .blue)
                    }
                    
                } else if let scores = history.buffer?.scores {
                    ForEach(0 ..< 1) { _ in
                        HistoryTableRowView(content: scores.map { $0.description })
                            .foregroundColor(.gray)
                    }
                }
            }
            
//            Spacer()

        }
//        .frame(maxHeight: historyViewHeight)

    }
    
    // MARK: - private constants
    private let historyViewHeight : CGFloat = 800.0
}

// MARK: - private views
typealias TableCellContent = String

fileprivate struct HistoryTableRowView: View {

    let content: [TableCellContent]
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            ForEach(content, id: \.self) { cell in
                HistoryTableCellView(content: cell)
                Spacer()
            }
        }
    }
}

fileprivate struct HistoryTableCellView: View {
    private let numberCellWidth : CGFloat = 60.0

    let content: TableCellContent
    var bold: Bool = false
    
    var body: some View {
        Text(content)
            .fontWeight(bold ? .bold : .none)
            .fixedSize()
            .frame(width: numberCellWidth)
    }
}

fileprivate struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

fileprivate struct HistorySampleView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
            ScoreHistoryView()
            Spacer()
            Button() {
                addScoresToHistory()
            } label: {
                Text("Add New Round")
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color(red: 180/255, green: 180/255, blue: 200/255, opacity: 0.8)
                            .cornerRadius(20)
            )
            .padding()
        }
        .emphasize(maxHeight: 800)
    }
    
    private func addScoresToHistory() {
        
        let players = settings.players
        
        for player in players.items {
            let sampleScore = Int.random(in: 0 ... 6)
            print ("Adding score \(sampleScore) to Player <\(player.name)>")
            player.add(score: sampleScore)
            player.saveScore()
        }
        
        settings.history.store(state: GameState(players: players.data))
        settings.objectWillChange.send()
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySampleView()
            .padding()
            .environmentObject(GameSettings())
    }
}
