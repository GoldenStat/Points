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
    var uiType: PlayerUIType = .numberBox
    
    var body: some View {
        
        switch uiType {
        case .checkbox(let num):
            BoxesScoreView(score: score, linesPerBox: num)
        case .numberBox: // add steps for the buttons?
            ButtonScoreView(score: score)
        case .matches:
            MatchesScoreView(score: score)
        case .selectionBox(let values):
            SelectionScoreView(score: score, selection: values)
        }
    }
}

struct ScoreRepresentationView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreRepresentationView(score: Score(5, buffer: 3),
                                uiType: .matches)
            .environmentObject(GameSettings())
    }
}
