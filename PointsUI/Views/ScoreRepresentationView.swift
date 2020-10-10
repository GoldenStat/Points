//
//  ScoreRepresentationView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a View that handles a score depending on the representation Type
struct ScoreRepresentationView: View {
    var score: Score
    var uiType: PlayerUIType
    
    var body: some View {
        switch uiType {
        case .checkbox(let num):
            ZStack {
                BoxesScoreView(score: score, linesPerBox: num)
                BufferView(score: score)
            }
            .aspectRatio(scoreBoardRatio, contentMode: .fit)

        case .numberBox: // add steps for the buttons?
            ButtonScoreView(score: score)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                .aspectRatio(scoreBoardRatio, contentMode: .fit)

        case .matches:
            ZStack {
                MatchesScoreView(score: score)
                BufferView(score: score)
            }

        case .selectionBox(let values):
            SelectionScoreView(score: score, selection: values)
                .aspectRatio(scoreBoardRatio, contentMode: .fit)
        }
        
    }

    // MARK: -- the local variables
    let scoreBoardRatio: CGFloat = 3/4

}

struct ScoreRepresentationView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreRepresentationView(score: Score(5, buffer: 3),
                                uiType: .checkbox(5))
            .environmentObject(GameSettings())
    }
}
