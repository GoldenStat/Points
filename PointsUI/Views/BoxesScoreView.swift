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
    
    var body: some View {
        LazyVGrid(columns: vGrid) {
            ForEach(0 ..< numberOfBoxes) { index in
            filledBox(at: index)
                .padding()
                .animation(.easeInOut(duration: .lineAnimationSpeed))
                .aspectRatio(ratio, contentMode: .fit)
            }
        }
    }
    
    // MARK: -- constants
    var maxScoreSettings : Int = 30 // { settings.maxPoints } // depends on game settings
    
    private let ratio : CGFloat = 1.0
    private let columns = 2 // make variable?

    // MARK: -- calculate points for each box
    private func filledBox(at index: Int) -> Box {
        // count points and buffer points to what should be in this box
        
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
        
        return Box(score: thisBoxScore, edges: linesPerBox)
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
