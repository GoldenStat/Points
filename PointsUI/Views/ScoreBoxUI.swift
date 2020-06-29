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
    
    var score: Score
    
    static let maxScore = GlobalSettings.scorePerGame
    static let columns = 2
    static let linesPerBox = Int(Box.maxLength)
    
    static var numberOfBoxes : Int { get {
        let overlay = Self.maxScore % Self.linesPerBox
        let ratio = Self.maxScore / Self.linesPerBox
        return ratio + (overlay > 0 ? 1 : 0)
        } }
        
    private func filledBox(at index: Int) -> Box {
        // count points and buffer points to what should be in this box
        
        let start = index * Self.linesPerBox
        let end = start + Self.linesPerBox
        var thisBoxScore = Score()
        
        for point in start ... end {
            if point < score.value {
                thisBoxScore.value += 1
            } else if point < score.sum {
                thisBoxScore.add()
            }
        }
        
        return Box(score: thisBoxScore)
    }
    
//    var boxes = (0 ..< ScoreBoxUI.numberOfBoxes).map { filledBox(at: $0) }
//
//    let columns : [ GridItem ] = [
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//    ]
//
//    let rows : [ GridItem ] = [
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//        GridItem(.adaptive(minimum: 80, maximum: 200)),
//    ]
    
    var body: some View {
        //        LazyVGrid(columns: columns) {
        //            LazyHGrid(rows: rows) {
        
        FlowStack(columns: ScoreBoxUI.columns,
                  numItems: ScoreBoxUI.numberOfBoxes) { index, colWidth in
            filledBox(at: index)
                .padding()
                .frame(width: colWidth)
                .animation(.easeInOut(duration: .lineAnimationSpeed))
        }.aspectRatio(ratio, contentMode: .fit)
        //            }
        //        }
    }
    
    private let ratio : CGFloat = 1.0 // 0.7
}

struct PlayerView_Previews: PreviewProvider {
    
    static func reroll(max value: Int) -> Score {
        let points: Int = max(0,min(value, ScoreBoxUI.maxScore))
        return Score(Int.random(in: 0 ... points))
    }
    
    static var previews: some View {
        VStack {
            ScoreBoxUI(score: reroll(max: 15))
        }
    }
}
