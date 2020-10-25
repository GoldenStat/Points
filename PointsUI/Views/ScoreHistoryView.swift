//
//  ScoreHistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 28.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Array where Element: StringExpressable {
    func stringElements() -> Array<String> {
        self.map { $0.description }
    }
}

func +<Element> (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> where Element: Numeric {
    guard lhs.count == rhs.count else { return lhs }
    var sum : Array<Element> = lhs
    for index in (0 ..< lhs.count) {
        sum[index] += rhs[index]
    }
    return sum
}

struct ScoreHistoryView: View {
    @EnvironmentObject var settings: GameSettings
    
    private var header: [ String ] { settings.playerNames }
    private var numberOfColumns: Int { header.count }
    private var history: History { settings.history }
    
    private var sumLine: [ Int ] {
        if let buffer = history.buffer {
            return (sumScores.last ?? zeroValues) + buffer.scores
        } else {
            return sumScores.last ?? zeroValues
        }
    }
   
    @State var showSums = false
    @State var showIndices = false

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
                            HistoryTableRowView(content: scores.stringElements())
                        }
//                    ForEach(0 ..< scoresForHistory.count) { index in
//                        if showIndices {
//                            HistoryTableRowView(content: scoresForHistory[index].stringElements(), index: index + 1)
//                        } else {
//                            HistoryTableRowView(content: scoresForHistory[index].stringElements())
//                        }
//                    }
                    
                    if showSums {
                        
                        BoldDivider()
                        
                        HStack {
                            HistoryTableRowView(content: sumLine.stringElements(), bold: true)
                                .foregroundColor(history.buffer == nil ? .black : .blue)
                        }
                        
                    } else if let scores = history.buffer?.scores {
                        ForEach(0 ..< 1) { _ in
                            HistoryTableRowView(content: scores.stringElements().map {"+\($0)"})
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.bottom)
    }
            
    
    // MARK: - scores' calculations
    
    /// all states' scores that are recorded for every round
    private var simpleScores: [[ Int ]] {
        var historyScores = history.states.map { $0.scores }
        if let buffer = history.buffer {
            historyScores.append(buffer.scores)
        }
        return historyScores
    }
    
    private var sumScores: [[ Int ]] {
        var sumScores: [[Int]] = [[]]
        var previousScores = zeroValues
        
        for state in history.states {
            var scoresSum: [Int] = previousScores
            for playerIndex in 0 ..< numberOfColumns {
                scoresSum[playerIndex] += state.scores[playerIndex]
            }
            sumScores.append(scoresSum)
            previousScores = scoresSum
        }
        return sumScores
    }
    
    private var scoresForHistory: [[ Int ]] {
        showSums ? simpleScores : sumScores
    }

    private var zeroValues : [ Int ] { [Int](repeating: 0, count: numberOfColumns) }

    private var isHistoryEmpty: Bool { history.states.isEmpty && history.buffer == nil }
 
}

// MARK: - private views
typealias TableCellContent = String

fileprivate struct HistoryTableRowView: View {

    let content: [TableCellContent]
    var bold: Bool = false
    var index: Int?
    
    var body: some View {
        ZStack {
        HStack(alignment: .center, spacing: 20) {
                if let index = index {
                    HStack {
                        HistoryTableCellView(content: index.description, bold: true)
                            .scaleEffect(scale)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                Spacer()
                ForEach(content, id: \.self) { cell in
                    HistoryTableCellView(content: cell, bold: bold)
                    Spacer()
                }
            }
        }
    }
    
    let scale : CGFloat = 0.6
}

fileprivate struct HistoryTableCellView: View {
    private let numberCellWidth : CGFloat = 60.0

    let content: TableCellContent
    var bold: Bool = false
    
    var body: some View {
        Text(content)
            .font(.system(size: 24))
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

fileprivate struct SampleButton: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
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
    
    private func addScoresToHistory() {
        
        let players = settings.players
        
        for player in players.items {
            let sampleScore = Int.random(in: 0 ... 6)
            print ("Adding score \(sampleScore) to Player <\(player.name)>")
            player.add(score: sampleScore)
            player.saveScore()
        }
        
        if settings.history.buffer != nil {
            settings.history.save()
        } else {
            settings.history.store(state: GameState(players: players.data))
        }
        settings.objectWillChange.send()
    }
}

fileprivate struct HistorySampleView : View {
    
    var body: some View {
        ZStack {
            SampleButton()
                .position(x: 200, y: 10)
            ScoreHistoryView()
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySampleView()
            .padding()
            .environmentObject(GameSettings())
    }
}
