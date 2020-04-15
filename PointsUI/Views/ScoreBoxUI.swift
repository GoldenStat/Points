//
//  PlayerView.swift
//  Points
//
//  Created by Alexander Völz on 18.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Double { static var lineAnimationSpeed = 0.2}


/// the UI with a collection of Boxes and maximum score
struct ScoreBoxUI: View, Identifiable {
    
    let id = UUID()
    
    var score: Int
    var tmpScore : Int
    
    static let maxScore = GlobalSettings.scorePerGame
    static let columns = 2
    static let linesPerBox = Int(Box.maxLength)
    
    static var numberOfBoxes : Int { get {
        let overlay = Self.maxScore % Self.linesPerBox
        let ratio = Self.maxScore / Self.linesPerBox
        return ratio + (overlay > 0 ? 1 : 0)
        } }
        
    private func filledBox(at index: Int) -> Box {
        // count points and tmp points to what should be in this box
        
        let start = index * Self.linesPerBox
        let end = start + Self.linesPerBox
        var thisBoxScore = 0
        var thisBoxTmpScore = 0
        
        for point in start ... end {
            if point < score {
                thisBoxScore += 1
            } else if point < score + tmpScore {
                thisBoxTmpScore += 1
            }
        }
        
        return Box(points: thisBoxScore, tmpPoints: thisBoxTmpScore)
    }
    
    var body: some View {
        VStack {    
            FlowStack(columns: Self.columns, numItems: Self.numberOfBoxes) { index, colWidth in
                self.filledBox(at: index)
                    .padding()
                    .frame(width: colWidth)
                    .animation(.easeInOut(duration: .lineAnimationSpeed))
            }.aspectRatio(0.7, contentMode: .fit)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    static func reroll(max score: Score) -> Score {
        let score = max(0,min(score, ScoreBoxUI.maxScore))
        return Score.random(in: 0 ... score)
    }
    
    static var previews: some View {
        VStack {
            ScoreBoxUI(score: reroll(max: 15), tmpScore: reroll(max: 5))
        }
    }
}
