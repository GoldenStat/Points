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
    @EnvironmentObject var settings: GameSettings
    var score: Score
    var uiType: PlayerUIType
        
    var body: some View {
        switch uiType {
        case .checkbox(let num):
            BoxesScoreView(score: score, linesPerBox: num)
                .buffered(score: score)
                .animation(.easeInOut(duration: .lineAnimationSpeed))

        case .numberBox: // add steps for the buttons?
            ButtonScoreView(score: score)

        case .scrollBox: // add steps for the buttons?
            ScrollScoreView(score: score)

        case .matches:
            MatchesScoreView(score: score)
                .padding()
                .buffered(score: score)
            
        case .selectionBox(_):
            let steps = settings.rule.scoreStep
            SelectionScoreView(score: score,
                               selection: steps.allValues)
        }
    }
}

extension View {
    func buffered(score: Score) -> some View {
        return ZStack {
            self
            if score.buffer != 0 {
                BufferView(score: score)
            }
        }
    }
}

struct ScoreRepresentationView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreRepresentationView(score: Score(5, buffer: 3),
                                uiType: .numberBox)
            .frame(width: 200, height: 400)
            .background(Color.yellow.opacity(0.2))
            .environmentObject(GameSettings())
    }
}
