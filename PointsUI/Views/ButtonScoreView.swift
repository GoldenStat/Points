//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ButtonScoreView: View {
    
    var score: Score
    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 1.0 }
    
    @State var scaleFactor: CGFloat = 1.0
    @State var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Text(score.value.description)
                .font(.system(size: 144, weight: .semibold, design: .rounded))
            BufferView(score: score)
                .scaleEffect(scaleFactor)
        }
        .onAppear() {
            withAnimation() {
                scaleFactor = 0.5
                offset = CGSize(width: 50, height: 50)
            }
        }
    }
}

struct ButtonScorePreviewView: View {
    @State var score = Score(0)
    var body: some View {
        ButtonScoreView(score: score)
            .onTapGesture(count: 2) {
                score.value += 1
            }
            .simultaneousGesture(
                TapGesture(count: 1)
                    .onEnded() {
                    score.buffer += 1
                })
    }
}
struct ButtonScoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonScorePreviewView(score: Score(10, buffer: 3))
    }
}
