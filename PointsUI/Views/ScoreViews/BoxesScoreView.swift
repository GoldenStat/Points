//
//  PlayerView.swift
//  Points
//
//  Created by Alexander Völz on 18.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Double { static var lineAnimationSpeed = 1.0 }

/// the UI with a collection of Boxes and maximum score
struct BoxesScoreView: View {
    @EnvironmentObject var settings: GameSettings
    
    let id = UUID()
    var score: Score = Score()
    var linesPerBox: Int = Int(EdgeShape.numberOfEdges)
    
    var numberOfBoxes : Int {
        let remainder = maxScoreSettings % linesPerBox
        let full = maxScoreSettings / linesPerBox
        return full + (remainder > 0 ? 1 : 0)
        }
    
    var vGrid: [GridItem] { [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ] }
    
    var boxes: [Box] {
        (0 ..< numberOfBoxes).map { index in
            Box(score: thisBoxScore(from: index), edges: linesPerBox)
        }
    }
    
    var body: some View {
        LazyVGrid(columns: vGrid) {
            ForEach(boxes) { box in
                box
                    .animation(.easeInOut(duration: .lineAnimationSpeed))
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
            }
        }        
    }
    
    // MARK: -- constants
    var maxScoreSettings : Int { min(maxScore, settings.maxPoints) }
    
    /// set a limit on boxes to draw - eventually these boxes are not feasible (add index marker and scroll views??
    var maxScore: Int { 6 * linesPerBox }
    
    // MARK: -- calculate points for each box
    /// count points and buffer points to what should be in the box at this index
    /// - parameter index: at what place is this box
    private func thisBoxScore(from index: Int) -> Score {
        
        let start = index * linesPerBox
        let end = start + linesPerBox
        var thisBoxScore = Score()
        
        for point in start ... end {
            if point < score.value {
                thisBoxScore.value += 1
            } else if point < score.sum {
                thisBoxScore.add()
            }
        }
        
        return thisBoxScore
    }
}

struct ScoreBoxUI_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            
            BoxesScoreView(score: Score(20), linesPerBox: 5)
                .environmentObject(GameSettings())
        }
    }
}
