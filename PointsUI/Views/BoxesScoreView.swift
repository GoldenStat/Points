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
    var linesPerBox: Int = Int(Box.maxLength)
    
    var numberOfBoxes : Int {
        let remainder = maxScoreSettings % linesPerBox
        let full = maxScoreSettings / linesPerBox
        return full + (remainder > 0 ? 1 : 0)
        }
    
    var body: some View {
        FlowStack(columns: columns,
                  numItems: numberOfBoxes) { index, colWidth in
            filledBox(at: index)
                .padding()
                .frame(width: colWidth)
                .animation(.easeInOut(duration: .lineAnimationSpeed))
                .aspectRatio(ratio, contentMode: .fit)
        }
    }
    
    // MARK: -- constants
    var maxScoreSettings : Int { settings.maxPoints } // depends on game settings
    
    private let ratio : CGFloat = 1.0
    private let columns = 2 // make variable?
//    private let linesPerBox = Int(Box.maxLength) // depends on how many points a Box struct can hold

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
        
        return Box(score: thisBoxScore)
    }
}

struct ScoreBoxUI_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            
            BoxesScoreView(score: Score(10))
                .environmentObject(GameSettings())
        }
    }
}
