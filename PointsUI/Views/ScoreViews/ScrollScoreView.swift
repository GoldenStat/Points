//
//  ScrollScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 21.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI


/// show Score
/// tap: enter scroll mode
/// scroll mode: show points above and below (score + buffer) like a one-armed bandit show just buffer as (+-buffer) in small upper left
/// scroll up or down
/// start timer, when it fires, register points
/// new tap: register points

struct ScrollScoreView: View {
    @EnvironmentObject var settings: GameSettings
    var score: Score
    var step : Int { settings.rule.scoreStep.defaultValue }

    let visibleSteps = 3
    let minZoom = 0.3
    let minOpacity = 0.2
    let maxZoom = 1.8
    
    let zoomingOpacity = 0.8
    let bufferColor = Color.pointbuffer
    
    @State private var isSelectingScore = true

    func registerPoints() {
        isSelectingScore = false
    }
    
    var bufferDescription : String {
        score.buffer > 0 ? "+\(score.buffer)" : "\(score.buffer)"
    }
    
    
    var body: some View {
        if isSelectingScore {
            scoreWheel
                .frame(width: 200, height: 300)
                .foregroundColor(.points)
                .background(Color.background)
                .overlay(ScalingTextView(bufferDescription)
                            .foregroundColor(bufferColor)
                            .scaleEffect(0.4)
                            .offset(x: 120, y: -200))

        } else {
        ScalingTextView(score.value.description)
            .foregroundColor(.points)
            .background(Color.background)
            .onTapGesture() {
                withAnimation() {
                    isSelectingScore.toggle()
                }
            }
        }
    }
    
    /// calculate a zoom factor for numbers further away from score
    /// linear interpolation
    func zoomFactor(for num: Int) -> CGFloat {
        guard score.sum != minNum, score.sum != -maxNum else { return CGFloat(minZoom) }
        let distFromScore = Double(abs(score.sum - num))

        // 0 < distFactor < 1
        let distFactor = distFromScore / Double(score.sum - minNum)
        
        return CGFloat(minZoom * distFactor + maxZoom * ( 1 - distFactor ))
    }

    /// all visible options during selection
    /// NOTE: assuming stride (scoreStep) of 1!
    var scoreNumbers: [Int] { [Int](minNum ... maxNum) }
    
    var minNum : Int { score.sum - visibleSteps }
    var maxNum : Int { score.sum + visibleSteps }

    var scoreWheel: some View {
        VStack(spacing: 10) {
            ForEach(scoreNumbers, id: \.self) { num in
                Text(num.description)
                    .scaleEffect(zoomFactor(for: num))
            }
        }
    }
}



struct ScrollScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollScoreView(score: Score(4, buffer: 20))
            .frame(width: 300, height: 400)
    }
}
